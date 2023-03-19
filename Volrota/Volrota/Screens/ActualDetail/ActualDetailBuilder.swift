// 
//  ActualDetailBuilder.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/17/23.
//

import UIKit
import XCoordinator

final class ActualDetailBuilder {
    
    static func build(
        router: WeakRouter<MainRoute>,
        props: MainViewController.MainViewControllerProps.ActualProps
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
