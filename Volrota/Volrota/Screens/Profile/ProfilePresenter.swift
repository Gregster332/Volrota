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

    // MARK: - Initialize

    init(
        view: ProfileViewControllerProtocol,
        router: WeakRouter<ProfileRoute>
    ) {
        self.view = view
        self.router = router
        initialize()
    }
    
    func initialize() {
        let props = ProfileViewController.ProfileProps(
            avatarImage: Images.profileMockLogo.image,
            userName: "Ded",
            closeButtonAction: dismiss,
            cells: [
                ProfileViewController.ProfileProps.ProfileCell(
                    title: "Редактировать профиль",
                    action: someAction
                ),
                ProfileViewController.ProfileProps.ProfileCell(
                    title: "События",
                    action: someAction
                )
            ]
        )
        
        view?.render(with: props)
    }
    
    func someAction() {
        print("dsdsdsd")
    }
    
    func dismiss() {
        router.trigger(.dismiss)
    }
}

// MARK: - Private Methods

private extension ProfilePresenter {
}
