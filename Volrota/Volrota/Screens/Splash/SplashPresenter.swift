// 
//  SplashPresenter.swift
//  Volrota
//
//  Created by Григорий on 30.12.2022.
//

import XCoordinator

protocol SplashPresenterProtocol: AnyObject {
    func openTabBar()
}

final class SplashPresenter: SplashPresenterProtocol {
    
    // MARK: - Properties
    private weak var view: SplashViewControllerProtocol?
    private let router: WeakRouter<RootRoute>
    private var applicationState: ApplicationState

    // MARK: - Initialize
    init(
        view: SplashViewControllerProtocol,
        router: WeakRouter<RootRoute>,
        applicationState: ApplicationState
    ) {
        self.view = view
        self.router = router
        self.applicationState = applicationState
    }
    
    func openTabBar() {
        let isOnboardingCompleted = applicationState.isOnboardingCompleted
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4)) { [weak self] in
            if isOnboardingCompleted {
                self?.router.trigger(.auth)
            } else {
                self?.router.trigger(.onboarding)
            }
        }
    }
}
