// 
//  AuthPresenter.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/31/23.
//

import XCoordinator

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
    
    private var organizations: [Organization] = []
    private var selectedOrganizationIndex: Int = -1
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
        let props = getDefaultProps(
            true,
            state: .inProgress(
                ProgressViewProps(
                    propgress: 0.0,
                    message: "Синхронизация")
            )
        )
        view?.render(with: props)
        
        lastUsedProps = props
        
        Task {
            do {
                
                let organizations = try? await database.getAllOrganizations()
                self.organizations = organizations?.compactMap { $0 } ?? []
                
                if let _ = authenticationService.currentUser {
                    
                    lastUsedProps = getDefaultProps(
                        false,
                        state: .inProgress(
                            ProgressViewProps(
                                propgress: 0.5,
                                message: "Пробую вход по логину/паролю"
                            )
                        )
                    )
                    
                    let user = await authenticationService.signIn(
                        keyChainService.userEmail ?? "",
                        keyChainService.userPassword ?? ""
                    )
                    if let user = user, !user.isEmpty {
                        openMainScreen()
                    }
                    
                    try await Task.sleep(nanoseconds: 1000000000)
                    
                    lastUsedProps = getDefaultProps(
                        false,
                        state: .inProgress(
                            ProgressViewProps(
                                propgress: 1,
                                message: "Пробую вход через Гугл"
                            )
                        )
                    )
                    
                    let googleUser = try await authenticationService.signInWithGoogle(vc: nil)
                    if !googleUser.uid.isEmpty {
                        openMainScreen()
                    }
                    
                    try await Task.sleep(nanoseconds: 1000000000)
                } else {
                    lastUsedProps = getDefaultProps(
                        false, state: .success
                    )
                }
            } catch {
                print(error)
                DispatchQueue.main.async {
                    let props = self.getDefaultProps(false, state: .failure)
                    self.view?.render(with: props)
                }
            }
        }
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
        
        if selectedOrganizationIndex == -1 {
            return
        }
        
        Task {
            do {
                let userId = try await authenticationService.signInWithGoogle(vc: view)
                
                if !userId.uid.isEmpty {
                    try? await database.createNewUser(
                        userId: userId.uid,
                        name: userId.displayName ?? "",
                        secondName: "",
                        organization: organizations[selectedOrganizationIndex].organizationId,
                        imageUrl: userId.photoURL?.absoluteString
                    )
                    openMainScreen()
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
            dropDownProps: DropDownTextFieldProps(
                items: organizations.compactMap { $0.name },
                chooseOrganizationCompletion: chooseOrganization
            ),
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
    
    func chooseOrganization(index: Int) {
        selectedOrganizationIndex = index
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
