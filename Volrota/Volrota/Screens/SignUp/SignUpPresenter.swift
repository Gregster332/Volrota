// 
//  SignUpPresenter.swift
//  Volrota
//
//  Created by Greg Zenkov on 4/1/23.
//

import Foundation
import XCoordinator

protocol SignUpPresenterProtocol: AnyObject {
    func initialAction()
    func signUp(_ name: String,
                _ secondName: String,
                _ email: String,
                _ password: String,
                _ image: UIImage)
}

final class SignUpPresenter: SignUpPresenterProtocol {
    
    // MARK: - Properties
    private weak var view: SignUpViewControllerProtocol?
    private let router: WeakRouter<AuthRoute>
    private let authenticationService: AuthService
    private let database: FirebaseDatabse
    private var keyChainAccess: KeychainService
    private let firebaseStorageSrevice: FirebaseStorage
    
    private var profileImageUrl: String = ""
    private var organizationsIds: [String: String] = [:]
    private var selectedOrganizationId: String = ""
    
    // MARK: - Initialize
    init(
        view: SignUpViewControllerProtocol,
        router: WeakRouter<AuthRoute>,
        authenticationService: AuthService,
        database: FirebaseDatabse,
        keyChainAccess: KeychainService,
        firebaseStorageSrevice: FirebaseStorage
    ) {
        self.view = view
        self.router = router
        self.authenticationService = authenticationService
        self.database = database
        self.keyChainAccess = keyChainAccess
        self.firebaseStorageSrevice = firebaseStorageSrevice
    }
    
    func initialAction() {
        Task {
            do {
                let organizations = try await database.getAllOrganizations()
                
                organizationsIds = organizations.reduce(into: [String: String]()) {
                    $0[$1.organizationId] = $1.name
                }
                
                let props = getDefaultProps(false, items: Array(organizationsIds.values))
                render(with: props)
            } catch {
                print(error)
            }
        }
    }
    
    func signUp(
        _ name: String,
        _ secondName: String,
        _ email: String,
        _ password: String,
        _ image: UIImage
    ) {
        let props = getDefaultProps(true, items: organizationsIds.values.sorted())
        render(with: props)
        Task {
            do {
                let createdUser = try await authenticationService.register(with: email, password)
                
                keyChainAccess.userEmail = email
                keyChainAccess.userPassword = password
                
                if !createdUser.uid.isEmpty {
                    try await database.createNewUser(userId: createdUser.uid, name: name, secondName: secondName, organization: selectedOrganizationId, imageUrl: nil)
                    
                    try await uploadImage(image)
                    
                    try await database.updateUserPhotoUrl(
                        with: authenticationService.currentUser?.uid ?? "",
                        profileImageUrl
                    )
                    
                    let props = getDefaultProps(false, items: organizationsIds.values.sorted())
                    render(with: props)
                    DispatchQueue.main.async {
                        self.router.trigger(.tabbar)
                    }
                }
                
            } catch {
                let props = getDefaultProps(false, items: organizationsIds.values.sorted())
                render(with: props)
            }
        }
    }
}

// MARK: - Private Methods

private extension SignUpPresenter {
    
    func getDefaultProps(_ isLoading: Bool, items: [String]) -> SignUpViewControllerProps {
        let props = SignUpViewControllerProps(
            sections: [
                .typing(
                    SignUpViewControllerProps.TypingSection(
                        title: Strings.SignUp.name,
                        cellProps: TypingCellProps(
                            tag: 0,
                            placeholder: Strings.SignUp.namePlaceholder
                        )
                    )
                ),
                .typing(
                    SignUpViewControllerProps.TypingSection(
                        title: Strings.SignUp.secondName,
                        cellProps: TypingCellProps(
                            tag: 1,
                            placeholder: Strings.SignUp.secondNamePlaceholder
                        )
                    )
                ),
                .dropDown(
                    SignUpViewControllerProps.OrganizationSection(
                        title: Strings.SignUp.organization,
                        cellProps: OrganizationsCellProps(
                            items: items,
                            chooseOrganizationCompletion: selectOrganization
                        )
                    )
                ),
                .typing(
                    SignUpViewControllerProps.TypingSection(
                        title: Strings.SignUp.email,
                        cellProps: TypingCellProps(
                            tag: 3,
                            placeholder: Strings.SignUp.emailPlaceholder
                        )
                    )
                ),
                .typing(
                    SignUpViewControllerProps.TypingSection(
                        title: Strings.SignUp.password,
                        cellProps: TypingCellProps(
                            tag: 4,
                            placeholder: Strings.SignUp.passwordPlaceholder
                        )
                    )
                )
            ],
            borderedButtonProps: BorderedButtonProps(
                text: Strings.SignUp.signUp,
                actionCompletion: nil,
                isLoading: isLoading
            ),
            selectImageCompletion: nil
        )
        return props
    }
    
    private func uploadImage(_ image: UIImage) async throws {
        do {
            let url = try await firebaseStorageSrevice.uploadPhoto(
                with: authenticationService.currentUser?.uid ?? "",
                name: "user_profile_pic",
                image: image
            )
            
            profileImageUrl = url
        } catch {
            throw error
        }
    }
    
    private func selectOrganization(with index: Int) {
        selectedOrganizationId = Array(organizationsIds.keys)[index]
    }
    
    func render(with props: SignUpViewControllerProps) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.render(with: props)
        }
    }
}
