// 
//  NewsBuilder.swift
//  Volrota
//
//  Created by Григорий on 30.12.2022.
//

import UIKit
import XCoordinator

final class NewsBuilder {
    
    static func build(router: WeakRouter<NewsRoute>) -> NewsViewController {
        let view = NewsViewController()
        let presenter = NewsPresenter(view: view, router: router)
        
        view.presenter = presenter
        return view
    }
}
