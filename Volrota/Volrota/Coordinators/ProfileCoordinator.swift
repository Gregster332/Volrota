//
//  ProfileCoordinator.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/18/23.
//

import XCoordinator

enum ProfileRoute: Route {
    case profile
    case dismiss
}

final class ProfileCoordinator: NavigationCoordinator<ProfileRoute> {
    
    private var dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        super.init(initialRoute: .profile)
    }
    
    override func prepareTransition(for route: ProfileRoute) -> NavigationTransition {
        switch route {
        case .profile:
            let profile = profile()
            return .set([profile])
        case .dismiss:
            return .dismiss()
        }
    }
    
    private func profile() -> UIViewController {
        let profile = ProfileBuilder.build(router: weakRouter)
        return profile
    }
}
