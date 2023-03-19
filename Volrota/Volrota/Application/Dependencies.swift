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
        
        return Dependencies(permissionService: permissionService)
    }
    
}

struct Dependencies {
    let permissionService: PermissionService
}
