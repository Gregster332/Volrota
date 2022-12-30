// 
//  MainPresenter.swift
//  Volrota
//
//  Created by Григорий on 30.12.2022.
//

import Foundation
import XCoordinator

protocol MainPresenterProtocol: AnyObject {
}

final class MainPresenter: MainPresenterProtocol {
    
    // MARK: - Properties
    private weak var view: MainViewControllerProtocol?
    private let router: WeakRouter<MainRoute>

    // MARK: - Initialize
    init(view: MainViewControllerProtocol, router: WeakRouter<MainRoute>) {
        self.view = view
        self.router = router
    }
}

// MARK: - Private Methods
private extension MainPresenter {
}
