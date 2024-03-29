// 
//  ActualDetailBuilder.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/17/23.
//

import UIKit
import XCoordinator
import GeneralServices

final class ActualDetailBuilder {
    
    static func build(
        router: WeakRouter<MainRoute>,
        props: GlobalModel.ActualModel
    ) -> ActualDetailViewController {
        
        let view = ActualDetailViewController()
        let presenter = ActualDetailPresenter(
            view: view,
            router: router,
            props: props)
        
        view.presenter = presenter
        return view
    }
}
