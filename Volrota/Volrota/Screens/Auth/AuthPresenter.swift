// 
//  AuthPresenter.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/31/23.
//

import Foundation
import XCoordinator

protocol AuthPresenterProtocol: AnyObject {
    func initialAction()
    func signIn(_ email: String, _ password: String)
}

final class AuthPresenter: AuthPresenterProtocol {
    
    // MARK: - Properties
    
    private weak var view: AuthViewControllerProtocol?
    private let router: WeakRouter<AuthRoute>
    private let authenticationService: AuthService
    private var keyChainService: KeychainService
    
    private let organizations: [String] = ["ДоброРФ", "Милосердие", "Хохлы"]
    
    // MARK: - Initialize
    init(
        view: AuthViewControllerProtocol,
        router: WeakRouter<AuthRoute>,
        authenticationService: AuthService,
        keyChainService: KeychainService
    ) {
        self.view = view
        self.router = router
        self.authenticationService = authenticationService
        self.keyChainService = keyChainService
    }
    
    func initialAction() {
        let props = getDefaultProps(true)
        view?.render(with: props)
        Task {
            do {
                if let _ = authenticationService.currentUser {
                    let user = try await authenticationService.signIn(
                        keyChainService.userEmail ?? "",
                        keyChainService.userPassword ?? ""
                    )
                    if !user.isEmpty {
                        openMainScreen()
                    }
                } else {
                    DispatchQueue.main.async {
                        let props = self.getDefaultProps(false)
                        self.view?.render(with: props)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    let props = self.getDefaultProps(false)
                    self.view?.render(with: props)
                }
            }
        }
    }
    
    func signIn(_ email: String, _ password: String) {
        
        let props = getDefaultProps(true)
        view?.render(with: props)
        
        Task {
            do {
                let userId = try await authenticationService.signIn(email, password)
                
                if !userId.isEmpty {
                    
                    keyChainService.userEmail = email
                    keyChainService.userPassword = password
                    
                    openMainScreen()
                }
            } catch {
                let props = getDefaultProps(false)
                DispatchQueue.main.async {
                    self.showFailureAlert()
                    self.view?.render(with: props)
                }
            }
        }
    }
}

// MARK: - Private Methods
private extension AuthPresenter {
    
    func getDefaultProps(_ isLoading: Bool) -> AuthViewControllerProps {
        
        let props = AuthViewControllerProps(
            sections: [
                AuthViewControllerProps.TypingSection(
                    title: "Почтовый адрес"
                ),
                AuthViewControllerProps.TypingSection(
                    title: "Пароль"
                )
            ],
            titleText: isLoading ?  "Еще пару секунд..." : "Войдите или зарегистрируйтесь через почту и пароль",
            signUpButtonAction: openSignUpScreen,
            borderedButtonProps: BorderedButtonProps(
                text: "Sign In",
                isLoading: isLoading
            )
        )
        return props
    }
    
    func openSignUpScreen() {
        router.trigger(.signUp)
    }
    
    func showFailureAlert() {
        let createAction = Alert.Action(
            title: "Создать",
            style: .destructive,
            action: createAccount
        )
        
        let cancelAction = Alert.Action(
            title: "Отмена",
            style: .cancel,
            action: nil
        )
        
        let alert = Alert(
            title: "Похоже, что такого пользователя не существует",
            message: "Создать аккаунт?",
            style: .alert,
            actions: [createAction, cancelAction]
        )
        
        router.trigger(.alert(alert))
    }
    
    func createAccount() {
        router.trigger(.signUp)
    }
    
    func openMainScreen() {
        let props = getDefaultProps(false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.view?.render(with: props)
            self?.router.trigger(.tabbar)
        }
    }
}
