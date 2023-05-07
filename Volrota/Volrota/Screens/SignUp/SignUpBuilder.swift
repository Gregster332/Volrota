// 
//  SignUpBuilder.swift
//  Volrota
//
//  Created by Greg Zenkov on 4/1/23.
//

import XCoordinator

final class SignUpBuilder {
    
    static func build(
        router: WeakRouter<AuthRoute>,
        authenticationService: AuthService,
        database: FirebaseDatabse,
        keyChainAccess: KeychainService,
        firebaseStorageSrevice: FirebaseStorage
    ) -> SignUpViewController {
        
        let view = SignUpViewController()
        let presenter = SignUpPresenter(
            view: view,
            router: router,
            authenticationService: authenticationService,
            database: database, keyChainAccess: keyChainAccess,
            firebaseStorageSrevice: firebaseStorageSrevice
        )
        
        view.presenter = presenter
        return view
    }
}
