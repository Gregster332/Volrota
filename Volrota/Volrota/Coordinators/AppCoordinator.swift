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
            return .push(onboarding)
        case .auth:
            let auth = auth()
            return .presentFullScreen(auth)
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
            applicationState: dependencies.applicationState)
        return onboarding
    }
    
    private func auth() -> AuthCoordinator {
        let auth = AuthCoordinator(dependencies: dependencies)
        return auth
    }
}
