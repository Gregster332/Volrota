// 
//  MapBuilder.swift
//  Volrota
//
//  Created by Greg Zenkov on 4/15/23.
//

import XCoordinator

final class MapBuilder {
    
    static func build(
        router: WeakRouter<EventsRoute>,
        locationService: LocationService,
        latitude: Double,
        longitude: Double
    ) -> MapViewController {
        
        let view = MapViewController()
        let presenter = MapPresenter(
            view: view,
            router: router,
            locationService: locationService,
            latitude: latitude,
            longitude: longitude
        )
        
        view.presenter = presenter
        return view
    }
}
