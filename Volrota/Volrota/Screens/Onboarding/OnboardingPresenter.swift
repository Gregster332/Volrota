// 
//  OnboardingPresenter.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/18/23.
//

import XCoordinator
import GeneralServices

protocol OnboardingPresenterProtocol: AnyObject {
    func initialize()
    //func accessNotifications()
}

final class OnboardingPresenter: OnboardingPresenterProtocol {
    
    // MARK: - Properties
    private weak var view: OnboardingViewControllerProtocol?
    private let router: WeakRouter<RootRoute>
    private let permissionService: PermissionService
    private let locationService: PermissionService
    private var applicationState: ApplicationState
    private let authenticationService: AuthService

    // MARK: - Initialize
    init(
        view: OnboardingViewControllerProtocol,
        router: WeakRouter<RootRoute>,
        permissionService: PermissionService,
        locationService: PermissionService,
        applicationState: ApplicationState,
        authenticationService: AuthService
    ) {
        self.view = view
        self.router = router
        self.permissionService = permissionService
        self.locationService = locationService
        self.applicationState = applicationState
        self.authenticationService = authenticationService
        initialize()
    }
    
    func initialize() {
        Task(priority: .high) {
            
            let _ = await locationService.request()
            
            DispatchQueue.main.async {
                self.view?.render(
                    with: OnboardingProps(
                        borderedButtonProps: BorderedButtonProps(
                            text: Strings.Onboarding.continue,
                            actionCompletion: self.accessNotifications
                        )
                    )
                )
            }
        }
    }
}

// MARK: - Private Methods
private extension OnboardingPresenter {
    
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
