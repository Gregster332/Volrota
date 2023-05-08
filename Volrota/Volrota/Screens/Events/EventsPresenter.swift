// 
//  EventsPresenter.swift
//  Volrota
//
//  Created by Greg Zenkov on 4/8/23.
//

import XCoordinator
import CoreLocation
import GeneralServices

enum FilteringKeys: CaseIterable {
    case assignedToUser
    case expiredSoon
    
    var cellName: String {
        switch self {
        case .assignedToUser:
            return Strings.Events.alreadySubscribed
        case .expiredSoon:
            return Strings.Events.expiredSoon
        }
    }
}

protocol EventsPresenterProtocol: AnyObject {
    func initialize()
    func filterEvents(with index: Int)
}

final class EventsPresenter: EventsPresenterProtocol {
    
    // MARK: - Properties
    private weak var view: EventsViewControllerProtocol?
    private let router: WeakRouter<EventsRoute>
    private let databaseService: FirebaseDatabse
    private let authenticationService: AuthService
    private let locationService: LocationService
    
    private var events: [EventsModel.EventModel] = []
    private var filteredEvents: [EventsModel.EventModel] = []
    private var usersEventsIds: [String] = []
    private var currentUserLocation: CLLocation?
    private var filteringKeys: [FilteringKeys?] = Array(repeating: nil, count: 3) {
        didSet {
            let key = filteringKeys.compactMap{ $0 }.first
            if let key = key {
                switch key {
                case .assignedToUser:
                    filteredEvents = filteredEvents.filter { usersEventsIds.contains($0.eventId) }
                case .expiredSoon:
                    filteredEvents = filteredEvents.filter { $0.endDate.dateValue().isDateExpiredSoon() }
//                case .near:
//                    filteredEvents = filteredEvents.filter {
//                        abs($0.lat - (currentUserLocation?.coordinate.latitude ?? 0.0)) < 0.04 &&
//                        abs($0.long - (currentUserLocation?.coordinate.longitude ?? 0.0)) < 0.04
//                    }
                }
            } else {
                filteredEvents = events
            }
            renderProps(models: filteredEvents)
        }
    }

    // MARK: - Initialize
    init(
        view: EventsViewControllerProtocol,
        router: WeakRouter<EventsRoute>,
        databaseService: FirebaseDatabse,
        authenticationService: AuthService,
        locationService: LocationService
    ) {
        self.view = view
        self.router = router
        self.databaseService = databaseService
        self.authenticationService = authenticationService
        self.locationService = locationService
    }
    
    func initialize() {
        Task {
            do {
                let eventModels = try await databaseService.getEvents(nil)
                usersEventsIds = await databaseService.getUserInfo(by: authenticationService.currentUser?.uid ?? "")?.eventsIds ?? []
                currentUserLocation = await locationService.getUserLocation()
                
                events = eventModels
                filteredEvents = eventModels
                
                var cells = eventModels.map {
                    mapCell(with: $0)
                }
                
                let locals = eventModels.filter {
                    abs($0.lat - (currentUserLocation?.coordinate.latitude ?? 0.0)) < 0.05 &&
                    abs($0.long - (currentUserLocation?.coordinate.longitude ?? 0.0)) < 0.05
                }.map {
                    mapCell(with: $0)
                }
                
                cells = Array(Set(cells).subtracting(locals))
                
                let props = EventsViewControllerProps(
                    events: [
                        .locals(locals),
                        .others(cells)
                    ],
                    eventTapCompletion: openEvent
                )
                DispatchQueue.main.async {
                    self.view?.render(with: props)
                }
            } catch {
                print(error)
            }
        }
    }
    
    func filterEvents(with index: Int) {
        let filter = FilteringKeys.allCases[index]
        
        if filteringKeys[index] != nil {
            filteringKeys[index] = nil
        } else {
            filteringKeys[index] = filter
        }
    }
}

// MARK: - Private Methods
private extension EventsPresenter {
    
    func reload() {
        renderProps(models: events)
    }
    
    func openEvent(with indexPath: IndexPath) {
        let item = filteredEvents[indexPath.item]
        router.trigger(.eventDetail(item))
    }
    
    func renderProps(models: [EventsModel.EventModel]) {
        DispatchQueue.global(qos: .utility).async {
            let cells = models.map {
                return EventsViewControllerProps.EventItem(
                    name: $0.eventTitle,
                    imageUrl: $0.eventImageURL,
                    date: Date.datePeriod(
                        from: $0.startDate.dateValue(),
                        endDate: $0.endDate.dateValue()),
                    place: self.getEventLocation($0.lat, $0.long)
                )
            }
            
            let props = EventsViewControllerProps(
                events: [
                    .others(cells)
                ],
                eventTapCompletion: self.openEvent
            )
            DispatchQueue.main.async {
                self.view?.render(with: props)
            }
        }
    }
    
    func getEventLocation(_ lat: Double, _ long: Double) -> String {
        let location = CLLocation(
            latitude: lat,
            longitude: long
        ).fetchPlaceFullName()
        return "\(location?.locality ?? ""), \(location?.name ?? "")"
    }
    
    func mapCell(with event: EventsModel.EventModel) -> EventsViewControllerProps.EventItem {
        let item = EventsViewControllerProps.EventItem(
            name: event.eventTitle,
            imageUrl: event.eventImageURL,
            date: Date.datePeriod(
                from: event.startDate.dateValue(),
                endDate: event.endDate.dateValue()),
            place: getEventLocation(event.lat, event.long)
        )
        return item
    }
}
