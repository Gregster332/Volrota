// 
//  ProfilePresenter.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/17/23.
//

import Foundation
import XCoordinator

protocol ProfilePresenterProtocol: AnyObject {
    func initialize()
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
        initialize()
    }
    
    func initialize() {
        let props = getDefaultProps(true)
        view?.render(with: props)
        loadUserInfoTask = Task {
            do {
                let user = await databse.getUserInfo(by: authenticationService.currentUser?.uid ?? "")
                let organization = try await databse.getOrganizationBy(user?.organizationId ?? "")
                
                let props = ProfileProps(
                    isLoading: false,
                    profileSettingsCells: [
                        ProfileProps.ProfileSettingsCell(
                            title: Strings.Profile.editProfile,
                            textColor: .black,
                            action: someAction
                        ),
                        ProfileProps.ProfileSettingsCell(
                            title: Strings.Profile.events,
                            textColor: .black,
                            action: someAction
                        ),
                        ProfileProps.ProfileSettingsCell(
                            title: Strings.Profile.signOut,
                            textColor: .systemRed,
                            action: logOut
                        )
                    ],
                    aboutHeaderViewProps:
                        ProfileProps.AboutHeaderViewProps(
                            profileImageUrl: user?.profileImageUrl ?? "",
                            fullName: (user?.name ?? "") + " " + (user?.secondName ?? ""),
                            organizationName: organization.name,
                            organizationImageUrl: organization.imageUrl
                        )
                    
                )
                
                await render(with: props)
            } catch {
                print(error)
            }
        }
    }
    
    func someAction() {
        print("dsdsdsd")
    }
    
    func logOut() {
        loadUserInfoTask?.cancel()
        keyChainService.userEmail = nil
        keyChainService.userPassword = nil
        authenticationService.logOut()
        NotificationCenter.default.post(name: .logOut, object: nil)
        router.trigger(.pop)
    }
    
    private func getDefaultProps(_ isLoading: Bool) -> ProfileProps {
        let props = ProfileProps(
            isLoading: isLoading
        )
        return props
    }
    
    @MainActor
    func render(with props: ProfileProps) {
        view?.render(with: props)
    }
}
