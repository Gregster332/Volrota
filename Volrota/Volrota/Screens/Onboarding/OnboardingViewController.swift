// 
//  OnboardingViewController.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/18/23.
//

import UIKit
import Lottie

protocol OnboardingViewControllerProtocol: AnyObject {
    
    func render(with props: OnboardingViewController.OnboardingProps)
}

final class OnboardingViewController: UIViewController, OnboardingViewControllerProtocol {
    
    struct OnboardingProps {
        let continueButtonAction: (() -> Void)?
    }
    
    // MARK: - Properties
    
    // swiftlint:disable implicitly_unwrapped_optional
    var presenter: OnboardingPresenterProtocol!
    // swiftlint:enable implicitly_unwrapped_optional
    private var continueButtonAction: (() -> Void)?
    
    // MARK: - Views
    
    private let titleLabel = UILabel()
    private let animationView = LottieAnimationView(name: "envelope")
    private let continueButton = BorderedButton(text: "Продолжить", background: Colors.accentColor.color, titleColor: .black, fontSize: 16, fontWeight: .regular, cornerRadius: 16)

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addViews()
        setupConstraints()
    }
    
    // MARK: - Methods
    
    func render(with props: OnboardingViewController.OnboardingProps) {
        continueButtonAction = props.continueButtonAction
    }
}

// MARK: - Private Methods

private extension OnboardingViewController {
    
    func setupView() {
        
        view.do {
            $0.backgroundColor = .white
        }
        
        titleLabel.do {
            $0.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
            $0.textAlignment = .left
            $0.numberOfLines = 0
            $0.textColor = .black
            $0.text = "Включите уведомления, чтобы быть вкурсе последних новостей. Так же можно изменить в настройках"
        }
        
        animationView.do {
            $0.animationSpeed = 1.5
            $0.loopMode = .repeat(.infinity)
            $0.contentMode = .scaleAspectFill
            $0.play()
        }
        
        continueButton.addTarget(self, action: #selector(handleContinueButton), for: .touchUpInside)
    }
    
    func addViews() {
        
        view.addSubviews([titleLabel, animationView, continueButton])
    }
    
    func setupConstraints() {
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        animationView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.size.equalTo(view.frame.size.width)
            $0.centerX.equalToSuperview()
        }
        
        continueButton.snp.makeConstraints{
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
    }
    
    // MARK: - UI Actions
    
    @objc func handleContinueButton() {
        continueButtonAction?()
    }
}
