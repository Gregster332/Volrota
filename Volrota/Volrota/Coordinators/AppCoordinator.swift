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
    case tabbar
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
        case .tabbar:
            let tabBarCoordinator = tabbar()
            return .presentFullScreen(tabBarCoordinator)
        }
    }
    
    private func splash() -> UIViewController {
        let splashViewController = SplashBuilder.build(router: weakRouter)
        return splashViewController
    }
    
    private func onboarding() -> UIViewController {
        let onboarding = OnboardingBuilder.build(router: weakRouter, permissionService: dependencies.permissionService)
        return onboarding
    }
    
    private func tabbar() -> TabCoordinator {
        let tabBar = TabCoordinator(dependencies: dependencies)
        return tabBar
    }
}
