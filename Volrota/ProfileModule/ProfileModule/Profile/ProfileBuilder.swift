// 
//  ProfileBuilder.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/17/23.
//

import XCoordinator
import GeneralServices

final public class ProfileBuilder {
    
    public static func build(
        router: WeakRouter<ProfileRoute>,
        authenticationService: AuthService,
        keyChainService: KeychainService,
        databse: FirebaseDatabse,
        firebaseStorageService: FirebaseStorage
    ) -> ProfileViewController {
        
        let view = ProfileViewController()
        let presenter = ProfilePresenter(
            view: view,
            router: router,
            authenticationService: authenticationService,
            keyChainService: keyChainService, databse: databse, firebaseStorageService: firebaseStorageService)
        
        view.presenter = presenter
        return view
    }
}
