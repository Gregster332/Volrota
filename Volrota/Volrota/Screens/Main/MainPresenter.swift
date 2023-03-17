// 
//  MainPresenter.swift
//  Volrota
//
//  Created by Григорий on 30.12.2022.
//

import Foundation
import XCoordinator

protocol MainPresenterProtocol: AnyObject {
    func initialize()
    func error()
    func success()
    func openProfile()
}

final class MainPresenter: MainPresenterProtocol {
    
    // MARK: - Properties
    private weak var view: MainViewControllerProtocol?
    private let router: WeakRouter<MainRoute>

    // MARK: - Initialize
    init(view: MainViewControllerProtocol, router: WeakRouter<MainRoute>) {
        self.view = view
        self.router = router
        initialize()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            self.error()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(6)) {
            self.success()
        }
    }
    
    func initialize() {
        let props = MainViewController.MainViewControllerProps(
            profileViewTitle: "Главная",
            sections: [],
            mainViewControllerState: .loading,
            profileTapCompletion: nil
        )
        view?.render(with: props)
    }
    
    func error() {
        let props = MainViewController.MainViewControllerProps(
            profileViewTitle: "Главная",
            sections: [],
            mainViewControllerState: .error,
            profileTapCompletion: nil
        )
        view?.render(with: props)
    }
    
    func success() {
        let props = MainViewController.MainViewControllerProps(
            profileViewTitle: "Главная",
            sections: [
                .news([
                    MainViewController.MainViewControllerProps.NewsViewProps(
                        title: "Наша группа ВКонтакте! Все самое актуальное также там",
                        bannerTitle: "",
                        viewBackgroundColor: UIColor.systemBlue,
                        bannerBackgroundColor: UIColor.red,
                        titleColor: UIColor.white,
                        bannerTitleColor: UIColor.black
                    ),
                    MainViewController.MainViewControllerProps.NewsViewProps(
                        title: "Программа по обученю молодых специалистов в области IT",
                        bannerTitle: "",
                        viewBackgroundColor: UIColor.systemPink,
                        bannerBackgroundColor: UIColor.red,
                        titleColor: UIColor.white,
                        bannerTitleColor: UIColor.black
                    )
                ]),
                .events([
                    MainViewController.MainViewControllerProps.EventViewProps(
                        eventTitle: "Бойцовский кружок",
                        eventImage: Images.bred.image,
                        date: "26 мая 2023 10:00 - 18 августа 2023 10:00",
                        location: "Россия, Нижний Новгород, ул. Ванеева"
                    ),
                    MainViewController.MainViewControllerProps.EventViewProps(
                        eventTitle: "Бойцовский кружок",
                        eventImage: Images.bred.image,
                        date: "26 мая 2023 10:00 - 18 августа 2023 10:00",
                        location: "Россия, Нижний Новгород, ул. Ванеева"
                    ),
                    MainViewController.MainViewControllerProps.EventViewProps(
                        eventTitle: "Бойцовский кружок",
                        eventImage: Images.bred.image,
                        date: "26 мая 2023 10:00 - 18 августа 2023 10:00",
                        location: "Россия, Нижний Новгород, ул . Ванеева"
                    )
                ]),
                .actual([
                    MainViewController.MainViewControllerProps.ActualProps(
                        image: Images.oscar.image,
                        actualTitle: "Премия Оскар 2023. Как премия вернула свою популярность?"
                    ),
                    MainViewController.MainViewControllerProps.ActualProps(
                        image: Images.oscar.image,
                        actualTitle: "Премия Оскар 2023. Как премия вернула свою популярность?"
                    ),
                    MainViewController.MainViewControllerProps.ActualProps(
                        image: Images.oscar.image,
                        actualTitle: "Премия Оскар 2023. Как премия вернула свою популярность?"
                    ),
                    MainViewController.MainViewControllerProps.ActualProps(
                        image: Images.oscar.image,
                        actualTitle: "Премия Оскар 2023. Как премия вернула свою популярность?"
                    ),
                    MainViewController.MainViewControllerProps.ActualProps(
                        image: Images.oscar.image,
                        actualTitle: "Премия Оскар 2023. Как премия вернула свою популярность?"
                    )
                ]),
                .header([
                    MainViewController.MainViewControllerProps.HeaderProps(
                        headerTitle: "Нижний Новгород",
                        isLocationView: true,
                        watchingAllCompletion: nil
                    ),
                    MainViewController.MainViewControllerProps.HeaderProps(
                        headerTitle: "Мероприятия",
                        isLocationView: false,
                        watchingAllCompletion: openProfile
                    ),
                    MainViewController.MainViewControllerProps.HeaderProps(
                        headerTitle: "Актуальное",
                        isLocationView: false,
                        watchingAllCompletion: openProfile
                    )
                ])
            ],
            mainViewControllerState: .success,
            profileTapCompletion: openProfile
        )
        view?.render(with: props)
    }
    
    func openProfile() {
        router.trigger(.profile)
    }
}

// MARK: - Private Methods
private extension MainPresenter {
}
