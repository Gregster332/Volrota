// 
//  AddNewEventBuilder.swift
//  Volrota
//
//  Created by Greg Zenkov on 5/25/23.
//

import GeneralServices
import XCoordinator

final class AddNewEventBuilder {
    
    static func build(
        router: WeakRouter<EventsRoute>,
        storage: FirebaseStorage,
        database: FirebaseDatabse,
        locationService: LocationService
    ) -> AddNewEventViewController {
        
        let view = AddNewEventViewController()
        let presenter = AddNewEventPresenter(
            view: view,
            router: router,
            storage: storage,
            database: database,
            locationService: locationService
        )
        
        view.presenter = presenter
        return view
    }
}
