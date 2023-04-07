//
//  Dependencies.swift
//  Volrota
//
//  Created by Григорий on 30.12.2022.
//

import Foundation

extension SceneDelegate {
    
    func dependencies() -> Dependencies {
        
        let permissionService = NotificationsPermissionService()
        let locationPermissionService = LocationPermissionService()
        
        let firebaseDatabase = DefaultFirebaseDatabse()
        
        let applicationState = UserDefaultsApplicationState()
        
        let locationService = DefaultLocationService()
        
        let authenticationService = DefaultAuthService()
        
        let keyChainService = DefaultKeychainService()
        
        let firebaseStorageService = DefaultFirebaseStorage()
        
        return Dependencies(
            permissionService: permissionService,
            locationPermissionService: locationPermissionService,
            firebaseDatabse: firebaseDatabase,
            applicationState: applicationState,
            locationService: locationService,
            authenticationService: authenticationService,
            keyChainService: keyChainService,
            firebaseStorageService: firebaseStorageService
        )
    }
    
}

struct Dependencies {
    let permissionService: PermissionService
    let locationPermissionService: PermissionService
    let firebaseDatabse: FirebaseDatabse
    let applicationState: ApplicationState
    let locationService: LocationService
    let authenticationService: AuthService
    let keyChainService: KeychainService
    let firebaseStorageService: FirebaseStorage
}
