// 
//  SettingsBuilder.swift
//  Volrota
//
//  Created by Григорий on 30.12.2022.
//

import UIKit
import XCoordinator

final class SettingsBuilder {
    
    static func build(router: WeakRouter<SettingsRoute>) -> SettingsViewController {
        let view = SettingsViewController()
        let presenter = SettingsPresenter(view: view, router: router)
        
        view.presenter = presenter
        return view
    }
}