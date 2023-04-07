// 
//  OnboardingPresenter.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/18/23.
//

import Foundation
import XCoordinator

protocol OnboardingPresenterProtocol: AnyObject {
    func initialize()
    func accessNotifications()
}

final class OnboardingPresenter: OnboardingPresenterProtocol {
    
    // MARK: - Properties

    private weak var view: OnboardingViewControllerProtocol?
    private let router: WeakRouter<RootRoute>
    private let permissionService: PermissionService
    private let locationService: PermissionService
    private var applicationState: ApplicationState

    // MARK: - Initialize

    init(
        view: OnboardingViewControllerProtocol,
        router: WeakRouter<RootRoute>,
        permissionService: PermissionService,
        locationService: PermissionService,
        applicationState: ApplicationState
    ) {
        self.view = view
        self.router = router
        self.permissionService = permissionService
        self.locationService = locationService
        self.applicationState = applicationState
        initialize()
    }
    
    func initialize() {
        Task(priority: .high) {
            
            let status = await locationService.request()
            
            DispatchQueue.main.async {
                self.view?.render(
                    with: OnboardingViewController.OnboardingProps(
                        borderedButtonProps: BorderedButtonProps(
                            text: "Sign In",
                            actionCompletion: self.accessNotifications
                        )
                    )
                )
            }
        }
    }
    
    func accessNotifications() {
        Task {
            let _ = await permissionService.request()
            
            DispatchQueue.main.async { [weak self] in
                self?.applicationState.isOnboardingCompleted = true
                self?.router.trigger(.auth)
            }
        }
    }
}

// MARK: - Private Methods

private extension OnboardingPresenter {
}
