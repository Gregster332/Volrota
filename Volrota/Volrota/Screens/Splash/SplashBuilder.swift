// 
//  SplashBuilder.swift
//  Volrota
//
//  Created by Григорий on 30.12.2022.
//

import XCoordinator

final class SplashBuilder {
    
    static func build(
        router: WeakRouter<RootRoute>,
        applicationState: ApplicationState
    ) -> SplashViewController {
        
        let view = SplashViewController()
        let presenter = SplashPresenter(
            view: view,
            router: router,
            applicationState: applicationState
        )
        
        view.presenter = presenter
        return view
    }
}
