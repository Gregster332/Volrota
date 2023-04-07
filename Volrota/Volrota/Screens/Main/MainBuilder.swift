// 
//  MainBuilder.swift
//  Volrota
//
//  Created by Григорий on 30.12.2022.
//

import UIKit
import XCoordinator

final class MainBuilder {
    
    static func build(
        router: WeakRouter<MainRoute>,
        database: FirebaseDatabse,
        locationService: LocationService,
        authenticationService: AuthService
    ) -> MainViewController {
        let view = MainViewController()
        let presenter = MainPresenter(
            view: view,
            router: router,
            database: database,
            locationService: locationService,
            authenticationService: authenticationService
        )
        
        view.initialCompletion = presenter.fetchGlobalItems
        view.logOutAction = presenter.logOut
        return view
    }
}
