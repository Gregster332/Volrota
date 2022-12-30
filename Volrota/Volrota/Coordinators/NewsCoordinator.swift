//
//  NewsCoordinator.swift
//  Volrota
//
//  Created by Григорий on 30.12.2022.
//

import XCoordinator

enum NewsRoute: Route {
    case news
}

final class NewsCoordinator: NavigationCoordinator<NewsRoute> {
    
    private var dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        super.init(initialRoute: .news)
    }
    
    override func prepareTransition(for route: NewsRoute) -> NavigationTransition {
        switch route {
        case .news:
            let newsViewController = news()
            return .set([newsViewController])
        }
    }
    
    private func news() -> NewsViewController {
        let newsViewController = NewsBuilder.build(router: weakRouter)
        return newsViewController
    }
}

