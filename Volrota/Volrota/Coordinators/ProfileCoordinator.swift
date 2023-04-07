//
//  ProfileCoordinator.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/18/23.
//

import XCoordinator

enum ProfileRoute: Route {
    case profile
    case pop
}

final class ProfileCoordinator: NavigationCoordinator<ProfileRoute> {
    
    private var dependencies: Dependencies
    
    init(dependencies: Dependencies, rootViewController: UINavigationController) {
        self.dependencies = dependencies
        super.init(rootViewController: rootViewController, initialRoute: nil)
        trigger(.profile)
    }
    
    override func prepareTransition(for route: ProfileRoute) -> NavigationTransition {
        switch route {
        case .profile:
            let profile = profile()
            return .push(profile)
        case .pop:
            return .pop()
        }
    }
    
    private func profile() -> UIViewController {
        let profile = ProfileBuilder.build(router: weakRouter, authenticationService: dependencies.authenticationService, keyChainService: dependencies.keyChainService, databse: dependencies.firebaseDatabse, firebaseStorageService: dependencies.firebaseStorageService)
        return profile
    }
}
