//
//  TabBarCoordinator.swift
//  Volrota
//
//  Created by Григорий on 30.12.2022.
//

import XCoordinator

enum TabRoute: Route {
    case main
    case news
    case settings
}

final class TabCoordinator: TabBarCoordinator<TabRoute> {
    
    private let dependencies: Dependencies
    
    private let mainRouter: StrongRouter<MainRoute>
    private let newsRouter: StrongRouter<NewsRoute>
    private let settingsRouter: StrongRouter<SettingsRoute>
    
    convenience init(dependencies: Dependencies) {
        let mainCoordinator = MainCoordinator(dependencies: dependencies)
        mainCoordinator.rootViewController.tabBarItem = UITabBarItem(title: "Main",
                                                                        image: UIImage(systemName: "plus"),
                                                                        tag: 1)
        
        let newsCoordinator = NewsCoordinator(dependencies: dependencies)
        newsCoordinator.rootViewController.tabBarItem = UITabBarItem(title: "News",
                                                                        image: UIImage(systemName: "plus"),
                                                                        tag: 2)
        
        let settingsCoordinator = SettingsCoordinator(dependencies: dependencies)
        settingsCoordinator.rootViewController.tabBarItem = UITabBarItem(title: "Settings",
                                                                        image: UIImage(systemName: "plus"),
                                                                        tag: 3)
        
        self.init(dependencies: dependencies,
                  mainRouter: mainCoordinator.strongRouter,
                  newsRouter: newsCoordinator.strongRouter,
                  settingsRouter: settingsCoordinator.strongRouter
        )
        setupTabBarAppearance()
    }
    
    init(dependencies: Dependencies,
         mainRouter: StrongRouter<MainRoute>,
         newsRouter: StrongRouter<NewsRoute>,
         settingsRouter: StrongRouter<SettingsRoute>) {
        self.dependencies = dependencies
        self.mainRouter = mainRouter
        self.newsRouter = newsRouter
        self.settingsRouter = settingsRouter
        super.init(tabs: [mainRouter, newsRouter, settingsRouter], select: mainRouter)
    }
    
    override func prepareTransition(for route: TabRoute) -> TabBarTransition {
        switch route {
        case .main:
            return .select(mainRouter)
        case .news:
            return .select(newsRouter)
        case .settings:
            return .select(settingsRouter)
        }
    }
    
    private func setupTabBarAppearance() {
        rootViewController.view.backgroundColor = .white
        UITabBar.appearance().tintColor = .blue
        UITabBar.appearance().isTranslucent = false
        if #available(iOS 13.0, *) {
            let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            tabBarAppearance.shadowImage = nil
            tabBarAppearance.shadowColor = nil
            tabBarAppearance.backgroundColor = .white
            UITabBar.appearance().standardAppearance = tabBarAppearance
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
                UITabBar.appearance().standardAppearance = tabBarAppearance
            }
        }
        rootViewController.tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        rootViewController.tabBar.layer.shadowRadius = 10
        rootViewController.tabBar.layer.shadowColor = UIColor.black.cgColor
        rootViewController.tabBar.layer.shadowOpacity = 0.1
    }
}
