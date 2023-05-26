//
//  NewsCoordinator.swift
//  Volrota
//
//  Created by Григорий on 30.12.2022.
//

import XCoordinator
import ChatModule
import Utils

enum HelperRoute: Route {
    case news
}

final class HelperCoordinator: NavigationCoordinator<HelperRoute> {
    
    private var dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        super.init(initialRoute: .news)
    }
    
    override func prepareTransition(for route: HelperRoute) -> NavigationTransition {
        switch route {
        case .news:
            let chatHelper = ChatViewController()
            return .set([chatHelper])
        }
    }
    
    private func news() -> UIViewController {
        let helperViewController = HelperBuilder.build(router: weakRouter)
        return helperViewController
    }
}

