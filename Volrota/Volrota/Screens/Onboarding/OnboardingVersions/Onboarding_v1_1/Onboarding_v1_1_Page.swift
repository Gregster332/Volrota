//
//  Onboarding_v1_1_Page.swift
//  Volrota
//
//  Created by Greg Zenkov on 5/14/23.
//

import UIKit
import Lottie

final class Onboarding_v1_1_Page: UIViewController {
    // MARK: - Views
    private let titleLabel = UILabel()
    
    init(model: Onboarding_v1_1_Model) {
        super.init(nibName: nil, bundle: nil)
        configureViews(model: model)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addViews()
        setupConstraints()
    }
}

// MARK: - Private Methods
private extension Onboarding_v1_1_Page {
    
    func configureViews(model: Onboarding_v1_1_Model) {
        titleLabel.text = model.titleText
        let animationView = LottieAnimationView(name: "envelope")
        
        animationView.do {
            $0.animationSpeed = 1.5
            $0.loopMode = .repeat(.infinity)
            $0.contentMode = .scaleAspectFill
            $0.play()
        }
        
        view.addSubview(animationView)
        
        animationView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.size.equalTo(view.frame.size.width)
            $0.centerX.equalToSuperview()
        }
    }
    
    func setupView() {
        
        view.do {
            $0.backgroundColor = .white
        }
        
        titleLabel.do {
            $0.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
            $0.textAlignment = .left
            $0.numberOfLines = 0
            $0.textColor = .black
            $0.text = Strings.Onboarding.title
        }
    }
    
    func addViews() {
        view.addSubviews([titleLabel])
    }
    
    func setupConstraints() {
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
}

