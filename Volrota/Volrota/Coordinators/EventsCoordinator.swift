//
//  EventsCoordinator.swift
//  Volrota
//
//  Created by Greg Zenkov on 4/18/23.
//

import XCoordinator
import GeneralServices
import Utils
import PhotosUI

enum EventsRoute: Route {
    case events
    case eventDetail(EventsModel.EventModel)
    case map(Double, Double)
    case dismiss
    case addNewEvent
    case photoPicker(PHPickerViewController)
    case alert(Alert)
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
        case .addNewEvent:
            let addNewEvent = addNewEvent()
            return .push(addNewEvent)
        case .photoPicker(let photoPicker):
            return .present(photoPicker)
        case .alert(let alert):
            return .presentAlert(alert)
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
    
    private func addNewEvent() -> UIViewController {
        let addNewEvent = AddNewEventBuilder.build(
            router: weakRouter,
            storage: dependencies.firebaseStorageService,
            database: dependencies.firebaseDatabse,
            locationService: dependencies.locationService
        )
        return addNewEvent
    }
}
