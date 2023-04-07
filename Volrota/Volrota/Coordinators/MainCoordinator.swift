//
//  MainCoordinator.swift
//  Volrota
//
//  Created by Григорий on 30.12.2022.
//

import XCoordinator

enum MainRoute: Route {
    case main
    case profile
    case actualDetail(MainViewController.MainViewControllerProps.ActualProps)
    case appSettings
    case dismiss
}

final class MainCoordinator: NavigationCoordinator<MainRoute> {
    
    private var dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        super.init(initialRoute: .main)
    }
    
    override func prepareTransition(for route: MainRoute) -> NavigationTransition {
        switch route {
        case .main:
            let mainViewController = main()
            return .set([mainViewController])
        case .profile:
            let profile = profile()
            addChild(profile)
            return .none()
        case .actualDetail(let actualProps):
            let actualDetail = actualDetail(actualProps: actualProps)
            return .present(actualDetail)
        case .appSettings:
            return .appSettings()
        case .dismiss:
            return .dismissAndReload()
        }
    }
    
    private func main() -> UIViewController {
        let mainViewController = MainBuilder.build(
            router: weakRouter,
            database: dependencies.firebaseDatabse,
            locationService: dependencies.locationService,
            authenticationService: dependencies.authenticationService
        )
        return mainViewController
    }
    
    private func profile() -> ProfileCoordinator {
        let profile = ProfileCoordinator(dependencies: dependencies, rootViewController: rootViewController)
        return profile
    }
    
    private func actualDetail(
        actualProps: MainViewController.MainViewControllerProps.ActualProps
    ) -> UIViewController {
        let actualDetail = ActualDetailBuilder.build(
            router: weakRouter,
            props: actualProps
        )
        return actualDetail
    }
}
