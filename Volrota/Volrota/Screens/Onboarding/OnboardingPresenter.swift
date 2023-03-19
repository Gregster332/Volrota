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

    // MARK: - Initialize

    init(view: OnboardingViewControllerProtocol, router: WeakRouter<RootRoute>, permissionService: PermissionService) {
        self.view = view
        self.router = router
        self.permissionService = permissionService
        initialize()
    }
    
    func initialize() {
        view?.render(with: OnboardingViewController.OnboardingProps(continueButtonAction: accessNotifications))
    }
    
    func accessNotifications() {
        Task {
            let _ = await permissionService.request()
            
            DispatchQueue.main.async { [weak self] in
                self?.router.trigger(.tabbar)
            }
        }
    }
}

// MARK: - Private Methods

private extension OnboardingPresenter {
}
