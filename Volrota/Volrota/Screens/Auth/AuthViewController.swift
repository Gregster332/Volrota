// 
//  AuthViewController.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/31/23.
//

import UIKit
import GoogleSignIn

struct AuthViewControllerProps {

    var state: AuthState
    let signUpButtonAction: (() -> Void)?
    var borderedButtonProps: BorderedButtonProps?
    var signInWithGoogleButtonProps: BorderedButtonProps?
    
    enum AuthState {
        case inProgress(ProgressViewProps)
        case success
        case failure
    }
}

protocol AuthViewControllerProtocol: AnyObject, UIViewController {
    func render(with props: AuthViewControllerProps)
}

final class AuthViewController: UIViewController, AuthViewControllerProtocol {
    
    // MARK: - Properties
    // swiftlint:disable implicitly_unwrapped_optional
    var presenter: AuthPresenterProtocol!
    // swiftlint:enable implicitly_unwrapped_optional
    var initialAction: (() -> Void)?
    private var signUpButtonAction: (() -> Void)?
    
    // MARK: - Views
    private let segmentControl = UISegmentedControl(items: ["Логин/Пароль", "Google"])
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let signInButton = BorderedButton()
    private let signUpButton = UIButton()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addViews()
        setupConstraints()
        segmentControl.selectedSegmentIndex = 0
        setDefaultSignIn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.initialAction()
    }
    
    // MARK: - Methods
    func render(with props: AuthViewControllerProps) {
        switch props.state {
        case .inProgress(let progressProps):
            break
        case .success, .failure:
            signUpButtonAction = props.signUpButtonAction
            signInButton.render(with: props.borderedButtonProps)
        }
    }
}

// MARK: - Private Methods
private extension AuthViewController {
    
    func setupView() {
        
        self.do {
            $0.navigationItem.hidesBackButton = true
            $0.title = "Вход"
        }
        
        view.do {
            $0.backgroundColor = .white
        }
        
        segmentControl.do {
            $0.selectedSegmentTintColor = Colors.accentColor.color
            $0.addTarget(self, action: #selector(handleSegmentControl), for: .valueChanged)
        }
        
        emailTextField.do {
            $0.placeholder = "Почта"
            $0.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            $0.backgroundColor = .systemGray6
            $0.layer.cornerRadius = 12
            $0.setLeftPaddingPoints(15)
        }
        
        passwordTextField.do {
            $0.placeholder = "Пароль"
            $0.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            $0.backgroundColor = .systemGray6
            $0.layer.cornerRadius = 12
            $0.setLeftPaddingPoints(15)
        }
        
        signInButton.addTarget(
            target: self,
            action: #selector(handleSignInButton),
            for: .touchUpInside
        )
        
        signUpButton.do {
            $0.setTitle(Strings.Auth.createAccount, for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.addTarget(
                self,
                action: #selector(handleSignUpButton),
                for: .touchUpInside
            )
        }
    }
    
    func addViews() {
        view.addSubview(segmentControl)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
    }
    
    func setupConstraints() {
        
        segmentControl.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(segmentControl.snp.bottom).offset(26)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }
        
        signUpButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-8)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        signInButton.snp.makeConstraints {
            $0.bottom.equalTo(signUpButton.snp.top).offset(-8)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(54)
        }
    }
    
    func setDefaultSignIn() {
        UIView.animate(withDuration: 0.5) {
            self.emailTextField.layer.opacity = 1
            self.passwordTextField.layer.opacity = 1
        } completion: { _ in
            self.emailTextField.isHidden = false
            self.passwordTextField.isHidden = false
        }
    }
    
    func setGoogleSignIn() {
        UIView.animate(withDuration: 0.5) {
            self.emailTextField.layer.opacity = 0
            self.passwordTextField.layer.opacity = 0
        } completion: { _ in
            self.emailTextField.isHidden = true
            self.passwordTextField.isHidden = true
        }
    }
    
    // MARK: - UI Actions
    @objc func handleSignInButton() {
        if segmentControl.selectedSegmentIndex == 0 {
            let email = emailTextField.text
            let password = passwordTextField.text
            
            presenter.signIn(email, password)
        } else {
            presenter.signInWithGoggle(view: self)
        }
    }
    
    @objc func handleSegmentControl() {
        if segmentControl.selectedSegmentIndex == 0 {
            setDefaultSignIn()
        } else {
            setGoogleSignIn()
        }
    }
    
    @objc func handleSignUpButton() {
        signUpButtonAction?()
    }
    
    @objc func handleSignUpWithGoogleButton() {
        presenter.signInWithGoggle(view: self)
    }
}
