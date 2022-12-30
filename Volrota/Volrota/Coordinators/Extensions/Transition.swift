//
//  Transition.swift
//  Volrota
//
//  Created by Григорий on 30.12.2022.
//

import XCoordinator

extension Transition {
    
    static func presentFullScreen(_ presentable: Presentable) -> Transition {
        presentable.viewController?.modalPresentationStyle = .fullScreen
        return .present(presentable)
    }
    
}
