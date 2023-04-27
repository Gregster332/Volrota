// 
//  SettingsBuilder.swift
//  Volrota
//
//  Created by Григорий on 30.12.2022.
//

import XCoordinator

final class SettingsBuilder {
    
    static func build(
        router: WeakRouter<SettingsRoute>,
        permissionService: PermissionService,
        database: FirebaseDatabse,
        authenticationService: AuthService
    ) -> SettingsViewController {
        
        let view = SettingsViewController()
        let presenter = SettingsPresenter(
            view: view,
            router: router,
            permissionService: permissionService,
            database: database,
            authenticationService: authenticationService
        )
        
        view.initialCompletion = presenter.initialize
        view.viewWillDisappearCompletion = presenter.viewWillDisappaer
        return view
    }
}
