//
//  SettingsCoordinator.swift
//  Volrota
//
//  Created by Григорий on 30.12.2022.
//

import XCoordinator

enum SettingsRoute: Route {
    case settings
}

final class SettingsCoordinator: NavigationCoordinator<SettingsRoute> {
    
    private var dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        super.init(initialRoute: .settings)
    }
    
    override func prepareTransition(for route: SettingsRoute) -> NavigationTransition {
        switch route {
        case .settings:
            let settingsViewController = settings()
            return .set([settingsViewController])
        }
    }
    
    private func settings() -> SettingsViewController {
        let settingsViewController = SettingsBuilder.build(router: weakRouter)
        return settingsViewController
    }
}

