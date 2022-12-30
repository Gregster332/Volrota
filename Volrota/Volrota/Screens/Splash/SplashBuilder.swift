// 
//  SplashBuilder.swift
//  Volrota
//
//  Created by Григорий on 30.12.2022.
//

import UIKit
import XCoordinator

final class SplashBuilder {
    
    static func build(router: WeakRouter<RootRoute>) -> SplashViewController {
        let view = SplashViewController()
        let presenter = SplashPresenter(view: view, router: router)
        
        view.presenter = presenter
        return view
    }
}
