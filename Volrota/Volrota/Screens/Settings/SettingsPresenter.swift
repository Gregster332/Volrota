// 
//  SettingsPresenter.swift
//  Volrota
//
//  Created by Григорий on 30.12.2022.
//

import Foundation
import XCoordinator

protocol SettingsPresenterProtocol: AnyObject {
}

final class SettingsPresenter: SettingsPresenterProtocol {
    
    // MARK: - Properties
    private weak var view: SettingsViewControllerProtocol?
    private let router: WeakRouter<SettingsRoute>

    // MARK: - Initialize
    init(view: SettingsViewControllerProtocol, router: WeakRouter<SettingsRoute>) {
        self.view = view
        self.router = router
    }
}

// MARK: - Private Methods
private extension SettingsPresenter {
}
