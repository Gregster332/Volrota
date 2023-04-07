//
//  AuthCoordinator.swift
//  Volrota
//
//  Created by Greg Zenkov on 4/1/23.
//

import XCoordinator

enum AuthRoute: Route {
    case auth
    case signUp
    case tabbar
    case alert(Alert)
}

final class AuthCoordinator: NavigationCoordinator<AuthRoute> {
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        super.init(initialRoute: .auth)
    }
    
    override func prepareTransition(for route: AuthRoute) -> NavigationTransition {
        switch route {
        case .auth:
            let auth = auth()
            return .set([auth])
        case .signUp:
            let signUp = signUp()
            return .push(signUp)
        case .tabbar:
            let tabBarCoordinator = tabbar()
            return .presentFullScreen(tabBarCoordinator)
        case .alert(let alert):
            return .presentAlert(alert)
        }
    }
    
    private func auth() -> UIViewController {
        let auth = AuthBuilder.build(
            router: weakRouter,
            authenticationService: dependencies.authenticationService,
            keyChainService: dependencies.keyChainService
        )
        return auth
    }
    
    private func tabbar() -> TabCoordinator {
        let tabBar = TabCoordinator(dependencies: dependencies)
        return tabBar
    }
    
    private func signUp() -> UIViewController {
        let signUp = SignUpBuilder.build(router: weakRouter, authenticationService: dependencies.authenticationService, database: dependencies.firebaseDatabse, keyChainAccess: dependencies.keyChainService, firebaseStorageSrevice: dependencies.firebaseStorageService)
        return signUp
    }
}
