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
                let user = try await databse.getUserInfo(by: authenticationService.currentUser?.uid ?? "")
                let organization = try await databse.getOrganizationBy(user.organizationId)
                
                let props = ProfileViewController.ProfileProps(
                    isLoading: false,
                    profileSettingsCells: [
                        ProfileViewController.ProfileProps.ProfileSettingsCell(
                            title: "Редактировать профиль",
                            textColor: .black,
                            action: someAction
                        ),
                        ProfileViewController.ProfileProps.ProfileSettingsCell(
                            title: "События",
                            textColor: .black,
                            action: someAction
                        ),
                        ProfileViewController.ProfileProps.ProfileSettingsCell(
                            title: "Выйти",
                            textColor: .systemRed,
                            action: logOut
                        )
                    ],
                    aboutHeaderViewProps:
                        ProfileViewController.ProfileProps.AboutHeaderViewProps(
                            profileImageUrl: user.profileImageUrl,
                            fullName: user.name + " " + user.secondName,
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
    
    private func getDefaultProps(_ isLoading: Bool) -> ProfileViewController.ProfileProps {
        let props = ProfileViewController.ProfileProps(
            isLoading: isLoading
        )
        return props
    }
    
    @MainActor
    func render(with props: ProfileViewController.ProfileProps) {
        view?.render(with: props)
    }
}
