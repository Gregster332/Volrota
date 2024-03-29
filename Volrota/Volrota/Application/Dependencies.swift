//
//  Dependencies.swift
//  Volrota
//
//  Created by Григорий on 30.12.2022.
//

import Foundation
import GeneralServices

extension SceneDelegate {
    
    func dependencies() -> Dependencies {
        
        let permissionService = NotificationsPermissionService()
        let locationPermissionService = LocationPermissionService()
        
        let firebaseDatabase = DefaultFirebaseDatabse()
        
        let applicationState = UserDefaultsApplicationState()
        
        let locationService = DefaultLocationService()
        let keyChainService = DefaultKeychainService()
        
        let authenticationService = DefaultAuthService(keychainService: keyChainService)
        
        let firebaseStorageService = DefaultFirebaseStorage()
        
        let firebaseRemoteConfig = FirebaseRemoteConfigImpl()
        
        return Dependencies(
            permissionService: permissionService,
            locationPermissionService: locationPermissionService,
            firebaseDatabse: firebaseDatabase,
            applicationState: applicationState,
            locationService: locationService,
            authenticationService: authenticationService,
            keyChainService: keyChainService,
            firebaseStorageService: firebaseStorageService,
            firebaseRemoteConfig: firebaseRemoteConfig
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
    let firebaseRemoteConfig: FirebaseRemoteConfig
}
