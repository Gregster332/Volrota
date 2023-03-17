// 
//  SplashPresenter.swift
//  Volrota
//
//  Created by Григорий on 30.12.2022.
//

import Foundation
import XCoordinator

protocol SplashPresenterProtocol: AnyObject {
    func openTabBar()
}

final class SplashPresenter: SplashPresenterProtocol {
    
    // MARK: - Properties
    private weak var view: SplashViewControllerProtocol?
    private let router: WeakRouter<RootRoute>

    // MARK: - Initialize
    init(view: SplashViewControllerProtocol, router: WeakRouter<RootRoute>) {
        self.view = view
        self.router = router
    }
    
    func openTabBar() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4)) { [weak self] in
            self?.router.trigger(.tabbar)
        }
    }
}

// MARK: - Private Methods
private extension SplashPresenter {
}
