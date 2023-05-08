// 
//  EventDetailPresenter.swift
//  Volrota
//
//  Created by Greg Zenkov on 4/14/23.
//

import XCoordinator
import GeneralServices


protocol EventDetailPresenterProtocol: AnyObject {
}

final class EventDetailPresenter: EventDetailPresenterProtocol {
    
    // MARK: - Properties

    private weak var view: EventDetailViewControllerProtocol?
    private let router: WeakRouter<EventsRoute>
    private let database: FirebaseDatabse
    private let authenticationService: AuthService
    private let model: EventsModel.EventModel
    
    private var lastUsedProps: EventDetailViewControllerProps?

    // MARK: - Initialize

    init(view: EventDetailViewControllerProtocol, router: WeakRouter<EventsRoute>, database: FirebaseDatabse, authenticationService: AuthService, model: EventsModel.EventModel) {
        self.view = view
        self.router = router
        self.database = database
        self.authenticationService = authenticationService
        self.model = model
        
        setup(with: model)
    }
    
    func setup(with model: EventsModel.EventModel) {
        Task {
            let currentUserId = authenticationService.currentUser?.uid ?? ""
            let events = await database.getUserInfo(by: currentUserId)?.eventsIds
            if let events = events, events.contains(model.eventId) {
                DispatchQueue.main.async {
                    let props = self.getDefaultProps(with: .subscribed)
                    self.view?.render(with: props)
                }
            } else if model.endDate.dateValue() < Date() {
                DispatchQueue.main.async {
                    let props = self.getDefaultProps(with: .expired)
                    self.view?.render(with: props)
                }
            } else {
                DispatchQueue.main.async {
                    let props = self.getDefaultProps(with: .available)
                    self.view?.render(with: props)
                }
            }
        }
    }
}

// MARK: - Private Methods

private extension EventDetailPresenter {
    
    func getDefaultProps(with eventState: EventDetailViewControllerProps.State) -> EventDetailViewControllerProps {
        let props = EventDetailViewControllerProps(
            sections: [
                .imageTitle(
                    EventDetailViewControllerProps.ImageTitleSection(
                        imageUrl: model.eventImageURL,
                        titleText: model.eventTitle
                    )
                ),
                .description(
                    EventDetailViewControllerProps.DescriptionSection(
                        descriptionText: "2023-04-14 19:48:24.678989+0300 Volrota[55469:4482187] 10.4.0 - [FirebaseAnalytics][I-ACS800023] No pending snapshot to activate. SDK name: app_measurement 2023-04-14 19:48:24.686533+0300 Volrota[55469:4482187] 10.4.0 - [FirebaseAnalytics][I-ACS023012] Analytics collection enabled 2023-04-14 19:48:24.687565+0300 Volrota[55469:4482187] 10.4.0 - [FirebaseAnalytics][I-ACS023220] Analytics screen reporting is enabled. Call Analytics.logEvent(AnalyticsEventScreenView, parameters: [...]) to log a screen view event. To disable automatic screen reporting, set the flag FirebaseAutomaticScreenReportingEnabled to NO (boolean) in the Info.plist",
                        startDate: model.startDate.dateValue().toString(),
                        endDate: model.endDate.dateValue().toString()
                    )
                ),
                .location(
                    EventDetailViewControllerProps.LocationSection(
                        lat: model.lat,
                        long: model.long
                    )
                ),
                .subscribeEvent(
                    EventDetailViewControllerProps.SubscribeEventSection(
                        state: eventState,
                        didTapOnSubscribe: didTapOnSubscribe
                    )
                )
            ],
            didTapOnLocation: didTapOnLocation,
            eventState: eventState
        )
        
        return props
    }
    
    func didTapOnLocation() {
        router.trigger(
            .map(model.lat, model.long)
        )
    }
    
    func didTapOnSubscribe() {
        
        let props = getDefaultProps(with: .subscribed)
        
        Task {
            let currentEventId = model.eventId
            let currentUserId = authenticationService.currentUser?.uid ?? ""
            
            await database.updateUserEvents(with: currentEventId, userId: currentUserId)
            
            DispatchQueue.main.async {
                self.view?.render(with: props)
            }
        }
    }
}
