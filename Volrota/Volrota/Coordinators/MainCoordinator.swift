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
            return .push(profile)
        }
    }
    
    private func main() -> UIViewController {
        let mainViewController = MainBuilder.build(router: weakRouter)
        return mainViewController
    }
    
    private func profile() -> UIViewController {
        let controller = UIViewController()
        controller.view.backgroundColor = .white
        controller.title = "Профиль"
        return controller
    }
}
