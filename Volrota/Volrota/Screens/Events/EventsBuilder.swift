// 
//  EventsBuilder.swift
//  Volrota
//
//  Created by Greg Zenkov on 4/8/23.
//

import UIKit
import XCoordinator

final class EventsBuilder {
    
    static func build(router: WeakRouter<EventsRoute>, databaseService: FirebaseDatabse, authenticationService: AuthService) -> EventsViewController {
        let view = EventsViewController()
        let presenter = EventsPresenter(view: view, router: router, databaseService: databaseService, authenticationService: authenticationService)
        
        view.presenter = presenter
        return view
    }
}
