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
        
        return Dependencies(
            permissionService: permissionService,
            locationPermissionService: locationPermissionService,
            firebaseDatabse: firebaseDatabase,
            applicationState: applicationState,
            locationService: locationService
        )
    }
    
}

struct Dependencies {
    let permissionService: PermissionService
    let locationPermissionService: PermissionService
    let firebaseDatabse: FirebaseDatabse
    let applicationState: ApplicationState
    let locationService: LocationService
}
