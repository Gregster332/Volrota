// 
//  EventDetailBuilder.swift
//  Volrota
//
//  Created by Greg Zenkov on 4/14/23.
//

import XCoordinator
import GeneralServices
import Utils

final class EventDetailBuilder {
    
    static func build(router: WeakRouter<EventsRoute>, model: EventsModel.EventModel, database: FirebaseDatabse, authenticationService: AuthService) -> EventDetailViewController {
        let view = EventDetailViewController()
        let presenter = EventDetailPresenter(view: view, router: router, database: database, authenticationService: authenticationService, model: model)
        
        view.presenter = presenter
        return view
    }
}
