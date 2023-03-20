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
            return .presentFullScreen(profile)
        case .actualDetail(let actualProps):
            let actualDetail = actualDetail(actualProps: actualProps)
            return .push(actualDetail)
        }
    }
    
    private func main() -> UIViewController {
        let mainViewController = MainBuilder.build(
            router: weakRouter,
            database: dependencies.firebaseDatabse,
            locationService: dependencies.locationService
        )
        return mainViewController
    }
    
    private func profile() -> ProfileCoordinator {
        let profile = ProfileCoordinator(dependencies: dependencies)
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
