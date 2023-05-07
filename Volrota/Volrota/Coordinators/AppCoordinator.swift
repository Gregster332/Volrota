//
//  AppCoordinator.swift
//  Volrota
//
//  Created by Григорий on 30.12.2022.
//

import XCoordinator

enum RootRoute: Route {
    case splash
    case onboarding
    case auth
    case tabBar
}

final class AppCoordinator: NavigationCoordinator<RootRoute> {
    
    private var dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        super.init(initialRoute: .splash)
    }
    
    override func prepareTransition(for route: RootRoute) -> NavigationTransition {
        switch route {
        case .splash:
            let splashViewController = splash()
            return .set([splashViewController])
        case .onboarding:
            let onboarding = onboarding()
            return .presentFullScreen(onboarding)
        case .auth:
            let auth = auth()
            return .presentFullScreen(auth)
        case .tabBar:
            let tabbar = tabbar()
            return .presentFullScreen(tabbar)
        }
    }
    
    private func splash() -> UIViewController {
        let splashViewController = SplashBuilder.build(
            router: weakRouter,
            applicationState: dependencies.applicationState
        )
        return splashViewController
    }
    
    private func onboarding() -> UIViewController {
        let onboarding = OnboardingBuilder.build(
            router: weakRouter,
            permissionService: dependencies.permissionService,
            locationService: dependencies.locationPermissionService,
            applicationState: dependencies.applicationState,
            authenticationService: dependencies.authenticationService)
        return onboarding
    }
    
    private func auth() -> AuthCoordinator {
        let auth = AuthCoordinator(dependencies: dependencies)
        return auth
    }
    
    private func tabbar() -> TabCoordinator {
        let tabBar = TabCoordinator(dependencies: dependencies)
        return tabBar
    }
}
