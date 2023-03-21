// 
//  MainPresenter.swift
//  Volrota
//
//  Created by Григорий on 30.12.2022.
//

import XCoordinator
import FirebaseFirestore
import CoreLocation

typealias SomeReturningType = (
    ads: [GlobalModel.AdsModel]?,
    events: [GlobalModel.EventModel]?,
    actulas: [GlobalModel.ActualModel]?,
    currentLocation: CLLocation?)

final class MainPresenter {
    
    // MARK: - Properties
    private weak var view: MainViewControllerProtocol?
    private let router: WeakRouter<MainRoute>
    private let database: FirebaseDatabse
    private let locationService: LocationService
    
    private var loadingTask: Task<Void, Never>?

    // MARK: - Initialize
    init(
        view: MainViewControllerProtocol,
        router: WeakRouter<MainRoute>,
        database: FirebaseDatabse,
        locationService: LocationService
    ) {
        self.view = view
        self.router = router
        self.database = database
        self.locationService = locationService
    }
    
    func loading() {
        let props = MainViewController.MainViewControllerProps(
            sections: [],
            locationViewProps: nil,
            mainViewControllerState: .loading,
            profileTapCompletion: nil,
            actualTapCompletion: nil,
            refreshCompletion: nil
        )
        view?.render(with: props)
    }
    
    func renderError() {
        let props = MainViewController.MainViewControllerProps(
            sections: [],
            locationViewProps: nil,
            mainViewControllerState: .error,
            profileTapCompletion: nil,
            actualTapCompletion: nil,
            refreshCompletion: fetchGlobalItems
        )
        view?.render(with: props)
    }
    
    func fetchGlobalItems() {
        loading()
        loadingTask = Task(priority: .userInitiated) {
            do {
                let globalModel = try await database.getGlobalData()
                let curentLocation = await locationService.getUserLocation()
                let formattedEvents = try await formattedEvents(globalModel.events)
                let convertedAds = formattedAds(globalModel.ads)
                let convertedActuals = formattedActuals(globalModel.actuals)
               
                
                let props = MainViewController.MainViewControllerProps(
                    sections: [
                        .news(convertedAds),
                        .events(formattedEvents),
                        .actual(convertedActuals),
                        .header([
                            MainViewController.MainViewControllerProps.HeaderProps(
                                headerTitle: Strings.Main.eventsSectionTitle,
                                watchingAllCompletion: self.openProfile
                            ),
                            MainViewController.MainViewControllerProps.HeaderProps(
                                headerTitle: Strings.Main.actualsSectionTitle,
                                watchingAllCompletion: self.openProfile
                            )
                        ])
                    ],
                    locationViewProps: MainViewController.MainViewControllerProps.LocationViewProps(
                        locationName: try await locationService.fetchCityName(
                            location: curentLocation
                        ) ?? "Локация выключена",
                        locationViewTapCompletion: openLocationSettings
                    ),
                    mainViewControllerState: .success,
                    profileTapCompletion: self.openProfile,
                    actualTapCompletion: self.openActual,
                    refreshCompletion: self.fetchGlobalItems
                )
                
                DispatchQueue.main.async {
                    self.view?.render(with: props)
                }
            } catch {
                DispatchQueue.main.async {
                    self.renderError()
                }
            }
        }
    }
}

// MARK: - Private Methods
private extension MainPresenter {
    
    func formattedAds(_ ads: [GlobalModel.AdsModel]) -> [MainViewController.MainViewControllerProps.NewsViewProps] {
        var formattedAds = [MainViewController.MainViewControllerProps.NewsViewProps]()
        
        for ad in ads {
            let formattedAd = MainViewController.MainViewControllerProps.NewsViewProps(
                title: ad.title,
                bannerTitle: ad.bannerTitle,
                viewBackgroundColor: ad.viewBackgroundColor,
                bannerBackgroundColor: ad.bannerBackgroundColor,
                titleColor: ad.titleColor,
                bannerTitleColor: ad.bannerTitleColor)
            formattedAds.append(formattedAd)
        }
        
        return formattedAds
    }
    
    func formattedActuals(_ actuals: [GlobalModel.ActualModel]) -> [MainViewController.MainViewControllerProps.ActualProps] {
        var formattedActuals = [MainViewController.MainViewControllerProps.ActualProps]()
        
        for actual in actuals {
            let formattedActual = MainViewController.MainViewControllerProps.ActualProps(
                imageUrl: actual.imageUrl,
                actualTitle: actual.title,
                actualDescription: actual.descriptionText)
            formattedActuals.append(formattedActual)
        }
        
        return formattedActuals
    }
    
    func formattedEvents(
        _ events: [GlobalModel.EventModel]
    ) async throws -> [MainViewController.MainViewControllerProps.EventViewProps] {
        let locations = events.map { CLLocation(latitude: $0.lat, longitude: $0.long) }
        var places = [String]()
        var formattedEvents = [MainViewController.MainViewControllerProps.EventViewProps]()
        
        for location in locations {
            let placeData = try await CLLocation(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            ).placeData()
            
            let placeFullName = "\(placeData?.locality ?? ""), \(placeData?.name ?? "")"
            places.append(placeFullName)
        }
        
        for (index, event) in events.enumerated() {
            let formattedEvent = MainViewController.MainViewControllerProps.EventViewProps(
                eventTitle: event.eventTitle,
                eventImageURL: event.eventImageURL,
                datePeriod: Date.datePeriod(from: event.startDate.dateValue(), endDate: event.endDate.dateValue()),
                placeFullName: places[index])
            formattedEvents.append(formattedEvent)
        }
        
        return formattedEvents
    }
    
    func openProfile() {
        router.trigger(.profile)
    }
    
    func openLocationSettings() {
        router.trigger(.appSettings)
    }
    
    func openActual(props: MainViewController.MainViewControllerProps.ActualProps) {
        router.trigger(.actualDetail(props))
    }
}
