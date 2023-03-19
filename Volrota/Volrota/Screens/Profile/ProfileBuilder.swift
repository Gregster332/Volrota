// 
//  ProfileBuilder.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/17/23.
//

import UIKit
import XCoordinator

final class ProfileBuilder {
    
    static func build(
        router: WeakRouter<ProfileRoute>
    ) -> ProfileViewController {
        let view = ProfileViewController()
        let presenter = ProfilePresenter(
            view: view,
            router: router)
        
        view.presenter = presenter
        return view
    }
}
