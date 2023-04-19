//
//  MainCoordinator.swift
//  Volrota
//
//  Created by Григорий on 30.12.2022.
//

import XCoordinator

enum MainRoute: Route {
    case main
    case profile
    //case events
    case actuals
    case actualDetail(GlobalModel.ActualModel)
    case appSettings
    case dismiss
}

final class MainCoordinator: NavigationCoordinator<MainRoute> {
    
    private var dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        super.init(initialRoute: .main)
    }
    
    override func prepareTransition(for route: MainRoute) -> NavigationTransition {
        switch route {
        case .main:
            let mainViewController = main()
            return .set([mainViewController])
        case .profile:
            let profile = profile()
            addChild(profile)
            return .none()
//        case .events:
//            let events = events()
//            return .push(events)
        case .actuals:
            let actuals = actuals()
            return .push(actuals)
        case .actualDetail(let actualModel):
            let actualDetail = actualDetail(actualModel: actualModel)
            return .present(actualDetail)
        case .appSettings:
            return .appSettings()
        case .dismiss:
            return .dismissAndReload()
       
        }
    }
    
    private func main() -> UIViewController {
        let mainViewController = MainBuilder.build(
            router: weakRouter,
            database: dependencies.firebaseDatabse,
            locationService: dependencies.locationService,
            authenticationService: dependencies.authenticationService
        )
        return mainViewController
    }
    
    private func profile() -> ProfileCoordinator {
        let profile = ProfileCoordinator(
            dependencies: dependencies,
            rootViewController: rootViewController
        )
        return profile
    }
    
    private func actualDetail(
        actualModel: GlobalModel.ActualModel
    ) -> UIViewController {
        let actualDetail = ActualDetailBuilder.build(
            router: weakRouter,
            props: actualModel
        )
        return actualDetail
    }
    
//    private func eventDetail(eventModel: GlobalModel.EventModel) -> UIViewController {
//        let eventDetail = EventDetailBuilder.build(
//            router: weakRouter,
//            model: eventModel,
//            database: dependencies.firebaseDatabse,
//            authenticationService: dependencies.authenticationService
//        )
//        return eventDetail
//    }
    
//    private func events() -> UIViewController {
//        let events = EventsBuilder.build(
//            router: weakRouter,
//            databaseService: dependencies.firebaseDatabse,
//            authenticationService: dependencies.authenticationService
//        )
//        return events
//    }
    
    private func actuals() -> UIViewController {
        let actuals = ActualsBuilder.build(
            router: weakRouter,
            databaseService: dependencies.firebaseDatabse
        )
        return actuals
    }
    
//    private func map(lat: Double, long: Double) -> UIViewController {
//        let map = MapBuilder.build(
//            router: weakRouter,
//            locationService: dependencies.locationService,
//            latitude: lat,
//            longitude: long
//        )
//        return map
//    }
}
