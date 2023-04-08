// 
//  MainPresenter.swift
//  Volrota
//
//  Created by Григорий on 30.12.2022.
//

import XCoordinator
import FirebaseFirestore
import CoreLocation

final class MainPresenter {
    
    // MARK: - Properties
    private weak var view: MainViewControllerProtocol?
    private let router: WeakRouter<MainRoute>
    private let database: FirebaseDatabse
    private let locationService: LocationService
    private let authenticationService: AuthService
    
    private var loadingTask: Task<Void, Never>?

    // MARK: - Initialize
    init(
        view: MainViewControllerProtocol,
        router: WeakRouter<MainRoute>,
        database: FirebaseDatabse,
        locationService: LocationService,
        authenticationService: AuthService
    ) {
        self.view = view
        self.router = router
        self.database = database
        self.locationService = locationService
        self.authenticationService = authenticationService
    }
    
    func loading() {
        let props = MainViewControllerProps(
            sections: [],
            locationViewProps: nil,
            mainViewControllerState: .loading,
            profileViewProps: nil,
            actualTapCompletion: nil,
            refreshCompletion: nil
        )
        view?.render(with: props)
    }
    
    func renderError() {
        let props = MainViewControllerProps(
            sections: [],
            locationViewProps: nil,
            mainViewControllerState: .error,
            profileViewProps: nil,
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
                
                let profileImageUrl = try await database.getUserInfo(
                    by: authenticationService.currentUser?.uid ?? ""
                ).profileImageUrl
                
                let formattedEvents = format(globalModel.events)
                let convertedAds = formattedAds(globalModel.ads)
                let convertedActuals = formattedActuals(globalModel.actuals)
                
               
                
                let props = MainViewControllerProps(
                    sections: [
                        .news(convertedAds),
                        .events(formattedEvents),
                        .actual(convertedActuals),
                        .header([
                            MainViewControllerProps.HeaderProps(
                                headerTitle: Strings.Main.eventsSectionTitle,
                                watchingAllCompletion: self.openProfile
                            ),
                            MainViewControllerProps.HeaderProps(
                                headerTitle: Strings.Main.actualsSectionTitle,
                                watchingAllCompletion: self.openProfile
                            )
                        ])
                    ],
                    locationViewProps: MainViewControllerProps.LocationViewProps(
                        locationName: try await locationService.fetchCityName(
                            location: curentLocation
                        ) ?? Strings.Main.locationUnavailable,
                        locationViewTapCompletion: openLocationSettings
                    ),
                    mainViewControllerState: .success,
                    profileViewProps: ProfileViewProps(
                        navTitle: Strings.Main.mainTitle,
                        profileImageUrl: profileImageUrl,
                        profileTapCompletion: openProfile
                    ),
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
    
    func logOut() {
        router.trigger(.dismiss)
    }
}

// MARK: - Private Methods
private extension MainPresenter {
    
    func formattedAds(_ ads: [GlobalModel.AdsModel]) -> [MainViewControllerProps.NewsViewProps] {
        var formattedAds = [MainViewControllerProps.NewsViewProps]()
        
        for ad in ads {
            let formattedAd = MainViewControllerProps.NewsViewProps(
                title: ad.title,
                bannerTitle: ad.bannerTitle,
                viewBackgroundColor: UIColor(ad.viewBackgroundColor),
                bannerBackgroundColor: UIColor(ad.bannerBackgroundColor),
                titleColor: UIColor(ad.titleColor),
                bannerTitleColor: UIColor(ad.bannerTitleColor))
            formattedAds.append(formattedAd)
        }
        
        return formattedAds
    }
    
    func formattedActuals(_ actuals: [GlobalModel.ActualModel]) -> [MainViewControllerProps.ActualProps] {
        var formattedActuals = [MainViewControllerProps.ActualProps]()
        
        for actual in actuals {
            let formattedActual = MainViewControllerProps.ActualProps(
                imageUrl: actual.imageUrl,
                actualTitle: actual.title,
                actualDescription: actual.descriptionText)
            formattedActuals.append(formattedActual)
        }
        
        return formattedActuals
    }
    
    func format(_ events: [GlobalModel.EventModel]) -> [MainViewControllerProps.EventViewProps] {
        return events.map {
            let location = CLLocation(
                latitude: $0.lat,
                longitude: $0.long
            ).fetchPlaceFullName()
            let props = MainViewControllerProps.EventViewProps(
                eventTitle: $0.eventTitle,
                eventImageURL: $0.eventImageURL,
                datePeriod: Date.datePeriod(
                    from: $0.startDate.dateValue(),
                    endDate: $0.endDate.dateValue()),
                placeFullName: "\(location?.locality ?? ""), \(location?.name ?? "")")
            return props
        }
    }
    
    func openProfile() {
        router.trigger(.profile)
    }
    
    func openLocationSettings() {
        router.trigger(.appSettings)
    }
    
    func openActual(props: MainViewControllerProps.ActualProps) {
        router.trigger(.actualDetail(props))
    }
}
