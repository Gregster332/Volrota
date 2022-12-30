// 
//  NewsPresenter.swift
//  Volrota
//
//  Created by Григорий on 30.12.2022.
//

import Foundation
import XCoordinator

protocol NewsPresenterProtocol: AnyObject {
}

final class NewsPresenter: NewsPresenterProtocol {
    
    // MARK: - Properties
    private weak var view: NewsViewControllerProtocol?
    private let router: WeakRouter<NewsRoute>

    // MARK: - Initialize
    init(view: NewsViewControllerProtocol, router: WeakRouter<NewsRoute>) {
        self.view = view
        self.router = router
    }
}

// MARK: - Private Methods
private extension NewsPresenter {
}
