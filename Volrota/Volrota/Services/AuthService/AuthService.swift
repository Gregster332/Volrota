//
//  AuthService.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/31/23.
//

import FirebaseAuth
import GoogleSignIn

protocol AuthService {
    var currentUser: User? { get }
    func signIn(_ email: String, _ password: String) async -> String?
    func register(with email: String, _ password: String) async throws -> User
    func logOut()
    func signInWithGoogle(vc: UIViewController?) async throws -> User
}

final class DefaultAuthService: AuthService {
    
    private let authenticator: Auth
    private var keychainService: KeychainService
    
    var currentUser: User? {
        return authenticator.currentUser
    }
    
    init(keychainService: KeychainService) {
        authenticator = Auth.auth()
        self.keychainService = keychainService
    }
    
    func signIn(_ email: String, _ password: String) async -> String? {
        let result = try? await authenticator.signIn(withEmail: email, password: password)
        return result?.user.uid
    }
    
    func register(with email: String, _ password: String) async throws -> User {
        do {
            let result = try await authenticator.createUser(withEmail: email, password: password)
            return result.user
        } catch {
            throw error
        }
    }
    
    func logOut() {
        do {
           try authenticator.signOut()
        } catch {
            print(error)
        }
    }
    
    func signInWithGoogle(vc: UIViewController?) async throws -> User {
        do {
            if let idToken = keychainService.userGoogleIdToken, !idToken.isEmpty, let accessToken = keychainService.userGoogleAccessToken, !accessToken.isEmpty {
                
                let credentials = GoogleAuthProvider.credential(
                    withIDToken: idToken,
                    accessToken: accessToken
                )
                
                let result = try? await authenticator.signIn(with: credentials)
                if let result = result {
                    return result.user
                } else {
                    keychainService.userGoogleIdToken = nil
                    keychainService.userGoogleAccessToken = nil
                    throw AuthError.googleTokenExpired
                }
            } else {
                guard let vc = vc else {
                    throw AuthError.noVc
                }
                
                let user = try await GIDSignIn.sharedInstance.signIn(
                    withPresenting: vc
                ).user
                
                keychainService.userGoogleIdToken = user.idToken?.tokenString
                keychainService.userGoogleAccessToken = user.accessToken.tokenString
                
                guard let idToken = user.idToken else {
                    throw AuthError.nullIdToken
                }
                
                let newCredentials = GoogleAuthProvider.credential(
                    withIDToken: idToken.tokenString,
                    accessToken: user.accessToken.tokenString
                )
                
                let newResult = try await authenticator.signIn(with: newCredentials)
                
                return newResult.user
            }
        } catch {
            throw error
        }
    }
}

enum AuthError: Error {
    case noVc
    case nullIdToken
    case googleTokenExpired
}
