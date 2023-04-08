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
    private let logoImage = UIImageView()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addViews()
        setupConstraints()
        presenter.openTabBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimate()
    }
}

// MARK: - Private Methods
private extension SplashViewController {
    
    func setupView() {
        view.backgroundColor = Colors.accentColor.color
        
        logoImage.do {
            $0.image = Images.volhubLogo.image
            $0.contentMode = .scaleAspectFill
            $0.alpha = 0
        }
    }
    
    func addViews() {
        view.addSubviews([logoImage])
    }
    
    func setupConstraints() {
        logoImage.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(82)
            $0.centerY.equalToSuperview()
        }
    }
    
    func startAnimate() {
        UIView.animate(withDuration: 3, delay: 0, options: .curveEaseInOut) {
            self.logoImage.alpha = 1
        }
    }
}
