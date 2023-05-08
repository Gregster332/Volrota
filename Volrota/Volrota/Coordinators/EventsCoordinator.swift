//
//  EventsCoordinator.swift
//  Volrota
//
//  Created by Greg Zenkov on 4/18/23.
//

import XCoordinator
import GeneralServices
import Utils

enum EventsRoute: Route {
    case events
    case eventDetail(EventsModel.EventModel)
    case map(Double, Double)
    case dismiss
}

final class EventsCoordinator: NavigationCoordinator<EventsRoute> {
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        super.init(initialRoute: .events)
    }
    
    override func prepareTransition(for route: EventsRoute) -> NavigationTransition {
        switch route {
        case .events:
            let events = events()
            return .set([events])
        case .eventDetail(let eventModel):
            let eventDetail = eventDetail(eventModel: eventModel)
            return .push(eventDetail)
        case .map(let lat, let long):
            let map = map(lat: lat, long: long)
            return .present(map)
        case .dismiss:
            return .dismiss()
        }
    }
    
    private func events() -> UIViewController {
        let events = EventsBuilder.build(
            router: weakRouter,
            databaseService: dependencies.firebaseDatabse,
            authenticationService: dependencies.authenticationService,
            locationService: dependencies.locationService
        )
        return events
    }
    
    private func eventDetail(eventModel: EventsModel.EventModel) -> UIViewController {
        let eventDetail = EventDetailBuilder.build(
            router: weakRouter,
            model: eventModel,
            database: dependencies.firebaseDatabse,
            authenticationService: dependencies.authenticationService
        )
        return eventDetail
    }
    
    private func map(lat: Double, long: Double) -> UIViewController {
        let map = MapBuilder.build(
            router: weakRouter,
            locationService: dependencies.locationService,
            latitude: lat,
            longitude: long
        )
        return map
    }
}
