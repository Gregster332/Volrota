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
    func openActual(props: MainViewController.MainViewControllerProps.ActualProps)
}

final class MainPresenter: MainPresenterProtocol {
    
    // MARK: - Properties
    private weak var view: MainViewControllerProtocol?
    private let router: WeakRouter<MainRoute>
    
    private let testLongRead: String = "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?"

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
            profileTapCompletion: nil,
            actualTapCompletion: nil
        )
        view?.render(with: props)
    }
    
    func error() {
        let props = MainViewController.MainViewControllerProps(
            profileViewTitle: "Главная",
            sections: [],
            mainViewControllerState: .error,
            profileTapCompletion: nil,
            actualTapCompletion: nil
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
                        actualTitle: "Премия Оскар 2023. Как премия вернула свою популярность?",
                        actualLongRead: testLongRead
                    ),
                    MainViewController.MainViewControllerProps.ActualProps(
                        image: Images.oscar.image,
                        actualTitle: "Премия Оскар 2023. Как премия вернула свою популярность?",
                        actualLongRead: testLongRead
                    ),
                    MainViewController.MainViewControllerProps.ActualProps(
                        image: Images.oscar.image,
                        actualTitle: "Премия Оскар 2023. Как премия вернула свою популярность?",
                        actualLongRead: testLongRead
                    ),
                    MainViewController.MainViewControllerProps.ActualProps(
                        image: Images.oscar.image,
                        actualTitle: "Премия Оскар 2023. Как премия вернула свою популярность?",
                        actualLongRead: testLongRead
                    ),
                    MainViewController.MainViewControllerProps.ActualProps(
                        image: Images.oscar.image,
                        actualTitle: "Премия Оскар 2023. Как премия вернула свою популярность?",
                        actualLongRead: testLongRead
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
            profileTapCompletion: openProfile,
            actualTapCompletion: openActual
        )
        view?.render(with: props)
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
