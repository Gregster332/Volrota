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
    func configureControllers()
    func getSelectedIndex() -> Int
    func setSelectedIndex(_ index: Int)
    func nextScreen()
}

final class OnboardingPresenter: OnboardingPresenterProtocol {
    
    // MARK: - Properties
    private weak var view: OnboardingViewControllerProtocol?
    private let router: WeakRouter<RootRoute>
    private let permissionService: PermissionService
    private let locationService: PermissionService
    private var applicationState: ApplicationState
    private let remoteConfigService: FirebaseRemoteConfig
    
    private var selectedPageIndex: Int = 0

    // MARK: - Initialize
    init(
        view: OnboardingViewControllerProtocol,
        router: WeakRouter<RootRoute>,
        permissionService: PermissionService,
        locationService: PermissionService,
        applicationState: ApplicationState,
        remoteConfigService: FirebaseRemoteConfig
    ) {
        self.view = view
        self.router = router
        self.permissionService = permissionService
        self.locationService = locationService
        self.applicationState = applicationState
        self.remoteConfigService = remoteConfigService
        initialize()
    }
    
    func initialize() {
        Task(priority: .high) {
            let _ = await locationService.request()
        }
    }
    
    func getSelectedIndex() -> Int {
        return selectedPageIndex
    }
    
    func setSelectedIndex(_ index: Int) {
        selectedPageIndex = index
        view?.setupButtonTitle(with: "Продолжить")
    }
    
    func nextScreen() {
        accessNotifications()
    }
    
    func configureControllers() {
        let pages = configurePages()
        view?.update(with: pages)
        view?.setupButton(
            with: "Продолжить",
            backgroundColor: .black,
            textColor: .white
        )
    }
}

// MARK: - Private Methods
private extension OnboardingPresenter {
    
    func configurePages() -> [UIViewController] {
        let factory = OnboardingFactory()
        let onboardingVersion = remoteConfigService.onboardingVersion
        let pages = factory.build(with: onboardingVersion)
        return pages
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
