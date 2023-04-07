// 
//  ActualDetailPresenter.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/17/23.
//

import Foundation
import XCoordinator

protocol ActualDetailPresenterProtocol: AnyObject {
}

final class ActualDetailPresenter: ActualDetailPresenterProtocol {
    
    // MARK: - Properties

    private weak var view: ActualDetailViewControllerProtocol?
    private let router: WeakRouter<MainRoute>

    // MARK: - Initialize

    init(
        view: ActualDetailViewControllerProtocol,
        router: WeakRouter<MainRoute>,
        props: MainViewController.MainViewControllerProps.ActualProps
    ) {
        self.view = view
        self.router = router
        
        convertProps(props: props)
    }
}

// MARK: - Private Methods

private extension ActualDetailPresenter {
    
    func convertProps(
        props: MainViewController.MainViewControllerProps.ActualProps
    ) {
        let actualProps = ActualDetailViewController.ActualDetailViewControllerProps(
            imageUrl: props.imageUrl,
            actualTitle: props.actualTitle,
            descriptionText: props.actualDescription
        )
        view?.render(with: actualProps)
    }
}
