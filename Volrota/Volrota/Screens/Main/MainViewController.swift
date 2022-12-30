// 
//  MainViewController.swift
//  Volrota
//
//  Created by Григорий on 30.12.2022.
//

import UIKit

protocol MainViewControllerProtocol: AnyObject {
}

final class MainViewController: UIViewController, MainViewControllerProtocol {
    
    // MARK: - Properties
    var presenter: MainPresenterProtocol!
    
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
private extension MainViewController {
    
    func setupView() {
        view.backgroundColor = .green
    }
    
    func addViews() {
    }
    
    func setupConstraints() {
    }
    
    // MARK: - UI Actions
}
