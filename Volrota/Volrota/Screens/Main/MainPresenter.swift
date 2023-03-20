// 
//  MainPresenter.swift
//  Volrota
//
//  Created by Григорий on 30.12.2022.
//

import Foundation
import XCoordinator
import FirebaseFirestore

protocol MainPresenterProtocol: AnyObject {
    func initialize()
    func error()
    func success()
    func openProfile()
    func openActual(props: MainViewController.MainViewControllerProps.ActualProps)
}

final class MainPresenter: MainPresenterProtocol {
    
    // MARK: - Properties
    private weak var view: MainViewControllerProtocol?
    private let router: WeakRouter<MainRoute>
    private let database: FirebaseDatabse
    private let locationService: LocationService
    
    private let testLongRead: String = "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?"

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
        initialize()
        success()
    }
    
    func initialize() {
        let props = MainViewController.MainViewControllerProps(
            profileViewTitle: "Главная",
            sections: [],
            mainViewControllerState: .loading,
            profileTapCompletion: nil,
            actualTapCompletion: nil,
            refreshCompletion: nil
        )
        view?.render(with: props)
    }
    
    func error() {
        let props = MainViewController.MainViewControllerProps(
            profileViewTitle: "Главная",
            sections: [],
            mainViewControllerState: .error,
            profileTapCompletion: nil,
            actualTapCompletion: nil,
            refreshCompletion: success
        )
        view?.render(with: props)
    }
    
    func success() {
        Task(priority: .userInitiated) {
            do {
                let ads = try await database.detAdvertisments()
                let events = try await database.getEvents()
                let curentLocation = try await locationService.getUserLocation().fetchCityAndCountry()
                
                let props = MainViewController.MainViewControllerProps(
                    profileViewTitle: "Главная",
                    sections: [
                        .news(ads),
                        .events(events),
                        .actual([
                            MainViewController.MainViewControllerProps.ActualProps(
                                image: Images.oscar.image,
                                actualTitle: "Премия Оскар 2023. Как премия вернула свою популярность?",
                                actualLongRead: self.testLongRead
                            ),
                            MainViewController.MainViewControllerProps.ActualProps(
                                image: Images.oscar.image,
                                actualTitle: "Премия Оскар 2023. Как премия вернула свою популярность?",
                                actualLongRead: self.testLongRead
                            ),
                            MainViewController.MainViewControllerProps.ActualProps(
                                image: Images.oscar.image,
                                actualTitle: "Премия Оскар 2023. Как премия вернула свою популярность?",
                                actualLongRead: self.testLongRead
                            ),
                            MainViewController.MainViewControllerProps.ActualProps(
                                image: Images.oscar.image,
                                actualTitle: "Премия Оскар 2023. Как премия вернула свою популярность?",
                                actualLongRead: self.testLongRead
                            ),
                            MainViewController.MainViewControllerProps.ActualProps(
                                image: Images.oscar.image,
                                actualTitle: "Премия Оскар 2023. Как премия вернула свою популярность?",
                                actualLongRead: self.testLongRead
                            )
                        ]),
                        .header([
                            MainViewController.MainViewControllerProps.HeaderProps(
                                headerTitle: curentLocation,
                                isLocationView: true,
                                watchingAllCompletion: nil
                            ),
                            MainViewController.MainViewControllerProps.HeaderProps(
                                headerTitle: "Мероприятия",
                                isLocationView: false,
                                watchingAllCompletion: self.openProfile
                            ),
                            MainViewController.MainViewControllerProps.HeaderProps(
                                headerTitle: "Актуальное",
                                isLocationView: false,
                                watchingAllCompletion: self.openProfile
                            )
                        ])
                    ],
                    mainViewControllerState: .success,
                    profileTapCompletion: self.openProfile,
                    actualTapCompletion: self.openActual,
                    refreshCompletion: self.success
                )
                
                DispatchQueue.main.async {
                    self.view?.render(with: props)
                }
            } catch {
                DispatchQueue.main.async {
                    self.error()
                }
            }
        }
    }
    
    func openProfile() {
        router.trigger(.profile)
    }
    
    func openActual(props: MainViewController.MainViewControllerProps.ActualProps) {
        router.trigger(.actualDetail(props))
    }
}

// MARK: - Private Methods
private extension MainPresenter {
}
