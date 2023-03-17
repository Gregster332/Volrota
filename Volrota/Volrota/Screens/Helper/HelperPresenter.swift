// 
//  HelperPresenter.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/17/23.
//

import Foundation
import XCoordinator

protocol HelperPresenterProtocol: AnyObject {
}

final class HelperPresenter: HelperPresenterProtocol {
    
    // MARK: - Properties

    private weak var view: HelperViewControllerProtocol?
    private let router: WeakRouter<HelperRoute>

    // MARK: - Initialize

    init(view: HelperViewControllerProtocol, router: WeakRouter<HelperRoute>) {
        self.view = view
        self.router = router
    }
}

// MARK: - Private Methods

private extension HelperPresenter {
}
