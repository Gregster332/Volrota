// 
//  ActualsBuilder.swift
//  Volrota
//
//  Created by Greg Zenkov on 4/9/23.
//

import UIKit
import XCoordinator

final class ActualsBuilder {
    
    static func build(
        router: WeakRouter<MainRoute>,
        databaseService: FirebaseDatabse
    ) -> ActualsViewController {
        
        let view = ActualsViewController()
        let presenter = ActualsPresenter(
            view: view,
            router: router,
            databaseService: databaseService
        )
        
        view.presenter = presenter
        return view
    }
}
