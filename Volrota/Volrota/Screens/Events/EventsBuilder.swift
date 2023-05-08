// 
//  EventsBuilder.swift
//  Volrota
//
//  Created by Greg Zenkov on 4/8/23.
//

import XCoordinator
import GeneralServices

final class EventsBuilder {
    
    static func build(
        router: WeakRouter<EventsRoute>,
        databaseService: FirebaseDatabse,
        authenticationService: AuthService,
        locationService: LocationService
    ) -> EventsViewController {
        let view = EventsViewController()
        let presenter = EventsPresenter(
            view: view, router: router,
            databaseService: databaseService,
            authenticationService: authenticationService,
            locationService: locationService
        )
        
        view.presenter = presenter
        return view
    }
}
