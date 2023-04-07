//
//  SettingsCoordinator.swift
//  Volrota
//
//  Created by Григорий on 30.12.2022.
//

import XCoordinator

enum SettingsRoute: Route {
    case settings
    case appSettings
    case profile
    
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
        case .appSettings:
            return .appSettings()
        case .profile:
            let profile = profile()
            addChild(profile)
            return .none()
        }
    }
    
    private func settings() -> SettingsViewController {
        let settingsViewController = SettingsBuilder.build(router: weakRouter, permissionService: dependencies.permissionService, database: dependencies.firebaseDatabse, authenticationService: dependencies.authenticationService)
        return settingsViewController
    }
    
    private func profile() -> ProfileCoordinator {
        let profile = ProfileCoordinator(
            dependencies: dependencies,
            rootViewController: rootViewController
        )
        return profile
    }
}

