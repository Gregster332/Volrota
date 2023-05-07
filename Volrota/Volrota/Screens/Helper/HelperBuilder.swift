// 
//  HelperBuilder.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/17/23.
//

import XCoordinator

final class HelperBuilder {
    
    static func build(router: WeakRouter<HelperRoute>) -> HelperViewController {
        let view = HelperViewController()
        let presenter = HelperPresenter(view: view, router: router)
        
        view.presenter = presenter
        return view
    }
}
