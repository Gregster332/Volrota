// 
//  AuthBuilder.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/31/23.
//

import XCoordinator
import GeneralServices

final class AuthBuilder {
    
    static func build(
        router: WeakRouter<AuthRoute>,
        authenticationService: AuthService,
        keyChainService: KeychainService,
        database: FirebaseDatabse
    ) -> AuthViewController {
        
        let view = AuthViewController()
        let presenter = AuthPresenter(
            view: view,
            router: router,
            authenticationService: authenticationService,
            keyChainService: keyChainService,
            database: database
        )
        
        view.presenter = presenter
        return view
    }
}
