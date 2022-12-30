// 
//  NewsViewController.swift
//  Volrota
//
//  Created by Григорий on 30.12.2022.
//

import UIKit

protocol NewsViewControllerProtocol: AnyObject {
}

final class NewsViewController: UIViewController, NewsViewControllerProtocol {
    
    // MARK: - Properties
    var presenter: NewsPresenterProtocol!
    
    // MARK: - Views

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addViews()
        setupConstraints()
    }
    
    // MARK: - Methods
}

// MARK: - Private Methods
private extension NewsViewController {
    
    func setupView() {
        view.backgroundColor = .red
    }
    
    func addViews() {
    }
    
    func setupConstraints() {
    }
    
    // MARK: - UI Actions
}
