// 
//  AuthBuilder.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/31/23.
//

import UIKit
import XCoordinator

final class AuthBuilder {
    
    static func build(router: WeakRouter<AuthRoute>, authenticationService: AuthService, keyChainService: KeychainService) -> AuthViewController {
        let view = AuthViewController()
        let presenter = AuthPresenter(view: view, router: router, authenticationService: authenticationService, keyChainService: keyChainService)
        
        view.presenter = presenter
        return view
    }
}
