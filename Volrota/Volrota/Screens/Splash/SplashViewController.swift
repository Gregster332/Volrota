// 
//  SplashViewController.swift
//  Volrota
//
//  Created by Григорий on 30.12.2022.
//

import UIKit
import SnapKit

protocol SplashViewControllerProtocol: AnyObject {
}

final class SplashViewController: UIViewController, SplashViewControllerProtocol {
    
    // MARK: - Properties
    var presenter: SplashPresenterProtocol!
    
    // MARK: - Views
    private let welcomeLabel = UILabel()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addViews()
        setupConstraints()
        presenter.openTabBar()
    }
    
    // MARK: - Methods
}

// MARK: - Private Methods
private extension SplashViewController {
    
    func setupView() {
        view.backgroundColor = .white
        
        welcomeLabel.do {
            $0.text = "Welcome Splash"
            $0.font = UIFont.systemFont(ofSize: 20, weight: .medium)
            $0.textColor = .black
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
    }
    
    func addViews() {
        view.addSubviews([welcomeLabel])
    }
    
    func setupConstraints() {
        welcomeLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - UI Actions
}
