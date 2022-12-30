// 
//  SettingsViewController.swift
//  Volrota
//
//  Created by Григорий on 30.12.2022.
//

import UIKit

protocol SettingsViewControllerProtocol: AnyObject {
}

final class SettingsViewController: UIViewController, SettingsViewControllerProtocol {
    
    // MARK: - Properties
    var presenter: SettingsPresenterProtocol!
    
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
private extension SettingsViewController {
    
    func setupView() {
        view.backgroundColor = .systemBlue
    }
    
    func addViews() {
    }
    
    func setupConstraints() {
    }
    
    // MARK: - UI Actions
}
