// 
//  ProfilePresenter.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/17/23.
//

import XCoordinator
import PhotosUI
import Utils
import GeneralServices

protocol PhotoFilterDelegate: AnyObject {
    func pickImage(_ imageUrl: String)
}

protocol ProfilePresenterProtocol: AnyObject {
    func initialize()
    func openErrorAlert(with text: String)
    func dismiss()
    func presentPhotoPicker(picker: PHPickerViewController)
}

final class ProfilePresenter: ProfilePresenterProtocol {
    
    // MARK: - Properties
    private weak var view: ProfileViewControllerProtocol?
    private let router: WeakRouter<ProfileRoute>
    private let authenticationService: AuthService
    private var keyChainService: KeychainService
    private let databse: FirebaseDatabse
    private let firebaseStorageService: FirebaseStorage
    
    private var loadUserInfoTask: Task<Void, Never>?
    private var lastUsedProps: ProfileViewControllerProps = ProfileViewControllerProps(
        isLoading: true,
        cells: [],
        isEditingMode: false,
        isPhotoPickerPresented: false,
        didEndPhotoPicking: nil
    )
    
    // MARK: - Initialize
    init(
        view: ProfileViewControllerProtocol,
        router: WeakRouter<ProfileRoute>,
        authenticationService: AuthService,
        keyChainService: KeychainService,
        databse: FirebaseDatabse,
        firebaseStorageService: FirebaseStorage
    ) {
        self.view = view
        self.router = router
        self.authenticationService = authenticationService
        self.keyChainService = keyChainService
        self.databse = databse
        self.firebaseStorageService = firebaseStorageService
    }
    
    func initialize() {
        view?.render(with: lastUsedProps)
        loadUserInfoTask = Task {
            do {
                let user = await databse.getUserInfo(by: authenticationService.currentUser?.uid ?? "")
                let organization = await databse.getOrganizationBy(user?.organizationId ?? "")
                
                let props = ProfileViewControllerProps(
                    isLoading: false,
                    cells: [
                        .user(
                            ProfileViewControllerProps.UserCellProps(
                                profileImageUrl: user?.profileImageUrl ?? "",
                                fullName: user?.name ?? "",
                                changeUserNameAction: changeUserNameAction,
                                changeUserImageAction: changeUserImageAction,
                                didEndEditingAction: didEndEditingAction
                            )
                        ),
                        .organization(
                            ProfileViewControllerProps.OrganizationCell(
                                organizationName: organization?.name ?? "",
                                organizationImageUrl: organization?.imageUrl ?? ""
                            )
                        ),
                        .options(
                            [
                                ProfileViewControllerProps.ProfileSettingsCell(
                                    title: "События",
                                    textColor: .black,
                                    action: nil
                                ),
                                ProfileViewControllerProps.ProfileSettingsCell(
                                    title: "Выход",
                                    textColor: .red,
                                    action: logOut
                                ),
                                ProfileViewControllerProps.ProfileSettingsCell(
                                    title: "Удалить аккаунт",
                                    textColor: .red,
                                    action: nil
                                )
                            ]
                        )
                    ],
                    isEditingMode: false,
                    isPhotoPickerPresented: false,
                    didEndPhotoPicking: didEndPhotoPicking
                )
                
                lastUsedProps = props
                
                if Task.isCancelled {
                    return
                }
                
                await render(with: lastUsedProps)
            } catch {
                print(error)
            }
        }
    }
    
    func openErrorAlert(with text: String) {
        let action = Alert.Action(title: "Ok", style: .cancel, action: nil)
        let alert = Alert(title: text, message: nil, style: .alert, actions: [action])
        router.trigger(.alert(alert))
    }
    
    func dismiss() {
        router.trigger(.dismiss)
    }
    
    func presentPhotoPicker(picker: PHPickerViewController) {
        router.trigger(.photoPicker(picker))
    }
}

private extension ProfilePresenter {
    
    func changeUserNameAction() {
        lastUsedProps.isEditingMode = true
        view?.render(with: lastUsedProps)
    }
    
    func changeUserImageAction() {
        lastUsedProps.isPhotoPickerPresented = true
        view?.render(with: lastUsedProps)
    }
    
    func didEndEditingAction(name: String) {
        lastUsedProps.isLoading = true
        view?.render(with: lastUsedProps)
        Task(priority: .userInitiated) {
            do {
                try await databse.updateUserName(with: authenticationService.currentUser?.uid ?? "", name)
                await reloadUserName(name: name)
            }  catch {
                print(error)
            }
        }
    }
    
    @MainActor
    func reloadUserName(name: String) async {
        lastUsedProps.isEditingMode = false
        lastUsedProps.isLoading = false
        if let first = lastUsedProps.cells.first {
            switch first {
            case .user(let userProps):
                lastUsedProps.cells.remove(at: 0)
                var newProps = userProps
                newProps.fullName = name
                lastUsedProps.cells.insert(.user(newProps), at: 0)
                view?.render(with: lastUsedProps)
            default:
                break
            }
        }
    }
    
    func didEndPhotoPicking(with image: UIImage) {
        lastUsedProps.isLoading = true
        view?.render(with: lastUsedProps)
        let userId = authenticationService.currentUser?.uid ?? ""
        resizeImage(image: image) { image in
            if let image = image {
                self.router.trigger(
                    .imageEditor(image, userId, self)
                )
            }
        }
    }
    
    @MainActor
    func reloadImage(url: String) async {
        lastUsedProps.isPhotoPickerPresented = false
        lastUsedProps.isLoading = false
        if let first = lastUsedProps.cells.first {
            switch first {
            case .user(let userProps):
                var newProps = userProps
                newProps.profileImageUrl = url
                lastUsedProps.cells[0] = .user(newProps)
                view?.render(with: lastUsedProps)
            default:
                break
            }
        }
    }
    
    func resizeImage(image: UIImage, completion: @escaping (UIImage?) -> Void) {
        let imageData = image.jpegData(compressionQuality: 0.025)!
        let compressedImage = UIImage(data: imageData)
        completion(compressedImage)
    }
    
    func logOut() {
        loadUserInfoTask?.cancel()
        authenticationService.logOut()
        keyChainService.clear() {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .logOut, object: nil)
                self.router.trigger(.dismiss)
            }
        }
    }
    
    @MainActor
    func render(with props: ProfileViewControllerProps) {
        view?.render(with: props)
    }
}

extension ProfilePresenter: PhotoFilterDelegate {
    func pickImage(_ imageUrl: String) {
        if let cell = lastUsedProps.cells.first {
            switch cell {
            case .user(let oldUserProps):
                var newProps = oldUserProps
                newProps.profileImageUrl = imageUrl
                lastUsedProps.cells.removeFirst()
                lastUsedProps.cells.insert(.user(newProps), at: 0)
                DispatchQueue.main.async {
                    self.view?.render(with: self.lastUsedProps)
                }
            default:
                break
            }
        }
    }
}

public extension Notification.Name {
    static let logOut = Notification.Name("logOut")
    static let profileImageChanged = Notification.Name("profileImageChanged")
}
