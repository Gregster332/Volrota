// 
//  AuthPresenter.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/31/23.
//

import XCoordinator
import FirebaseAuth

protocol AuthPresenterProtocol: AnyObject {
    func initialAction()
    func signIn(_ email: String?, _ password: String?)
    func signInWithGoggle(view: UIViewController)
}

final class AuthPresenter: AuthPresenterProtocol {
    
    // MARK: - Properties
    
    private weak var view: AuthViewControllerProtocol?
    private let router: WeakRouter<AuthRoute>
    private let authenticationService: AuthService
    private var keyChainService: KeychainService
    private let database: FirebaseDatabse
    
    private var lastUsedProps: AuthViewControllerProps? {
        didSet {
            if let props = lastUsedProps {
                DispatchQueue.main.async {
                    self.view?.render(with: props)
                }
            }
        }
    }
    
    // MARK: - Initialize
    init(
        view: AuthViewControllerProtocol,
        router: WeakRouter<AuthRoute>,
        authenticationService: AuthService,
        keyChainService: KeychainService,
        database: FirebaseDatabse
    ) {
        self.view = view
        self.router = router
        self.authenticationService = authenticationService
        self.keyChainService = keyChainService
        self.database = database
    }
    
    func initialAction() {
        
        if let currentUser = authenticationService.currentUser, currentUser.isAnonymous {
            router.trigger(.signUp)
        }
        
        let props = getDefaultProps(
            true,
            state: .success
        )
        
        lastUsedProps = props
    }
    
    func signIn(_ email: String?, _ password: String?) {
        
        guard let email = email, let password = password else {
            return
        }
        
        let props = getDefaultProps(true, state: .success)
        view?.render(with: props)
        
        Task {
            let userId = await authenticationService.signIn(email, password)
            
            if let userId = userId, !userId.isEmpty {
                
                keyChainService.userEmail = email
                keyChainService.userPassword = password
                
                openMainScreen()
            } else {
                let props = getDefaultProps(false, state: .failure)
                DispatchQueue.main.async {
                    self.showFailureAlert()
                    self.view?.render(with: props)
                }
            }
        }
    }
    
    @MainActor
    func signInWithGoggle(view: UIViewController) {
        Task {
            do {
                let googleUser = try await authenticationService.signInWithGoogle(vc: view)
                if googleUser.email == keyChainService.userEmail {
                    let id = await authenticationService.signIn(
                        googleUser.email ?? "",
                        keyChainService.userPassword ?? ""
                    )
                    openMainScreen()
                } else {
                    DispatchQueue.main.async {
                        self.showFailureToSignInWithGoogle()
                    }
                }
            } catch {
                print(error)
            }
        }
    }
}

// MARK: - Private Methods
private extension AuthPresenter {
    
    func getDefaultProps(_ isLoading: Bool, state: AuthViewControllerProps.AuthState) -> AuthViewControllerProps {
        
        let props = AuthViewControllerProps(
            state: state,
            signUpButtonAction: openSignUpScreen,
            borderedButtonProps: BorderedButtonProps(
                text: Strings.Auth.signIn
            ),
            signInWithGoogleButtonProps: BorderedButtonProps(
                text: "Google"
            )
        )
        return props
    }
    
    func openSignUpScreen() {
        router.trigger(.signUp)
    }
    
    func showFailureAlert() {
        let createAction = Alert.Action(
            title: Strings.Auth.create,
            style: .destructive,
            action: createAccount
        )
        
        let cancelAction = Alert.Action(
            title: Strings.Auth.cancel,
            style: .cancel,
            action: nil
        )
        
        let alert = Alert(
            title: Strings.Auth.noSuchUser,
            message: Strings.Auth.createAccount,
            style: .alert,
            actions: [createAction, cancelAction]
        )
        
        router.trigger(.alert(alert))
    }
    
    func showFailureToSignInWithGoogle() {
        let action = Alert.Action(title: "Ok", style: .cancel, action: nil)
        let alert = Alert(title: "Не удалось войти через гугл", message: "Попробуйте вход по логину/паролю", style: .alert, actions: [action])
        router.trigger(.alert(alert))
    }
    
    func createAccount() {
        router.trigger(.signUp)
    }
    
    func openMainScreen() {
        let props = getDefaultProps(false, state: .success)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.view?.render(with: props)
            self?.router.trigger(.tabbar)
        }
    }
    
    @MainActor
    func render(with props: AuthViewControllerProps) {
        view?.render(with: props)
    }
}
