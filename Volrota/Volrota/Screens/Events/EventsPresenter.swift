// 
//  EventsPresenter.swift
//  Volrota
//
//  Created by Greg Zenkov on 4/8/23.
//

import XCoordinator
import CoreLocation

protocol EventsPresenterProtocol: AnyObject {
    func initialize()
}

final class EventsPresenter: EventsPresenterProtocol {
    
    enum FilteringKeys: CaseIterable {
        case noFilters
        case assignedToUser
        case expiredSoon
        
        var cellName: String {
            switch self {
            case .noFilters:
                return "Все"
            case .assignedToUser:
                return "Уже учавствую"
            case .expiredSoon:
                return "Скоро истечет"
            }
        }
    }
    
    // MARK: - Properties

    private weak var view: EventsViewControllerProtocol?
    private let router: WeakRouter<EventsRoute>
    private let databaseService: FirebaseDatabse
    private let authenticationService: AuthService
    
    private var events: [EventsModel.EventModel] = []
    private var usersEventsIds: [String] = []
    private let filteringKeys = FilteringKeys.allCases

    // MARK: - Initialize

    init(
        view: EventsViewControllerProtocol,
        router: WeakRouter<EventsRoute>,
        databaseService: FirebaseDatabse,
        authenticationService: AuthService
    ) {
        self.view = view
        self.router = router
        self.databaseService = databaseService
        self.authenticationService = authenticationService
    }
    
    func initialize() {
        Task {
            do {
                let eventModels = try await databaseService.getEvents(nil)
                usersEventsIds = await databaseService.getUserInfo(by: authenticationService.currentUser?.uid ?? "")?.eventsIds ?? []
                events = eventModels
                
                let cells = eventModels.map {
                    return EventsViewControllerProps.EventItem(
                        name: $0.eventTitle,
                        imageUrl: $0.eventImageURL,
                        date: Date.datePeriod(
                            from: $0.startDate.dateValue(),
                            endDate: $0.endDate.dateValue()),
                        place: getEventLocation($0.lat, $0.long)
                    )
                }
                
                let props = EventsViewControllerProps(
                    events: [
                        .filter([
                            FilteringKeys.noFilters.cellName,
                            FilteringKeys.assignedToUser.cellName,
                            FilteringKeys.expiredSoon.cellName
                        ]),
                        .events(cells)
                    ],
                    eventTapCompletion: openEvent,
                    filterTapCompletiom: filterEvents
                )
                DispatchQueue.main.async {
                    self.view?.render(with: props)
                }
            } catch {
                print(error)
            }
        }
    }
    
    
    func reload() {
        renderProps(models: events)
    }
    
    func openEvent(with indexPath: IndexPath) {
        let item = events[indexPath.item]
        router.trigger(.eventDetail(item))
    }
}

// MARK: - Private Methods

private extension EventsPresenter {
    
    func renderProps(models: [EventsModel.EventModel]) {
        
    }
    
    func getEventLocation(_ lat: Double, _ long: Double) -> String {
        let location = CLLocation(
            latitude: lat,
            longitude: long
        ).fetchPlaceFullName()
        return "\(location?.locality ?? ""), \(location?.name ?? "")"
    }
    
    func filterEvents(with index: Int) {
        DispatchQueue.global(qos: .utility).async {
            var filteredEvents: [EventsModel.EventModel] = []
            
            switch self.filteringKeys[index] {
            case .noFilters:
                filteredEvents = self.events
            case .assignedToUser:
                filteredEvents = self.events.filter { self.usersEventsIds.contains($0.eventId) }
            case .expiredSoon:
                filteredEvents = self.events.filter { $0.endDate.dateValue().isDateExpiredSoon() }
            }
            
            let cells = filteredEvents.map {
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
                    .filter([
                        FilteringKeys.noFilters.cellName,
                        FilteringKeys.assignedToUser.cellName,
                        FilteringKeys.expiredSoon.cellName
                    ]),
                    .events(cells)
                ],
                eventTapCompletion: self.openEvent,
                filterTapCompletiom: self.filterEvents
            )
            DispatchQueue.main.async {
                self.view?.render(with: props)
            }
        }
    }
    
//    func getAllEventsByIds() async -> [EventsModel.EventModel] {
////        let events = await withTaskGroup(
////            of: EventsModel.EventModel.self,
////            returning: [EventsModel.EventModel].self,
////            body: { taskGroup in
////
////                let userId = authenticationService.currentUser?.uid ?? ""
////                let eventsIds = await databaseService.getUserInfo(by: userId)?.eventsIds ?? []
////
////                for id in eventsIds {
////                    taskGroup.addTask {
////                        let event = try? await self.databaseService.getEvents(nil)
////                        return event!
////                    }
////                }
////
////                var events = [EventsModel.EventModel]()
////                for await result in taskGroup {
////                    events.append(result)
////                }
////                return events
////            }
////        )
//        let items = try? await databaseService.getEvents(nil)
//        return items
//    }
}
