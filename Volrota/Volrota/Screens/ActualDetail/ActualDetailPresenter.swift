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
        props: GlobalModel.ActualModel
    ) {
        self.view = view
        self.router = router
        
        convertProps(props: props)
    }
}

// MARK: - Private Methods
private extension ActualDetailPresenter {
    
    func convertProps(
        props: GlobalModel.ActualModel
    ) {
        let actualProps = ActualDetailViewControllerProps(
            sections: [
                .imageSection(
                    ActualDetailViewControllerProps.ImageSectionProps(
                        imageUrl: props.imageUrl
                    )
                ),
                .descriptionSection(
                    ActualDetailViewControllerProps.DescriptionSectionProps(
                        sectionTitle: props.title,
                        descriptionText: props.descriptionText
                    )
                )
            ]
        )
        view?.render(with: actualProps)
    }
}
