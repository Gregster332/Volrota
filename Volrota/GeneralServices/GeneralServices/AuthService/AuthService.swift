//
//  AuthService.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/31/23.
//

import FirebaseAuth
import GoogleSignIn

public protocol AuthService {
    var currentUser: User? { get }
    func signIn(_ email: String, _ password: String) async -> String?
    func register(with email: String, _ password: String) async throws -> User
    func logOut()
    func signInWithGoogle(vc: UIViewController?) async throws -> User
}

public final class DefaultAuthService: AuthService {
    
    private let authenticator: Auth
    private var keychainService: KeychainService
    
    public var currentUser: User? {
        return authenticator.currentUser
    }
    
    public init(keychainService: KeychainService) {
        authenticator = Auth.auth()
        self.keychainService = keychainService
    }
    
    public func signIn(_ email: String, _ password: String) async -> String? {
        do {
            let result = try await authenticator.signIn(withEmail: email, password: password)
            return result.user.uid
        } catch {
            
            return nil
        }
    }
    
    public func register(with email: String, _ password: String) async throws -> User {
        do {
            let result = try await authenticator.createUser(withEmail: email, password: password)
            return result.user
        } catch {
            throw error
        }
    }
    
    public func logOut() {
        do {
           try authenticator.signOut()
        } catch {
            print(error)
        }
    }
    
    @MainActor
    public func signInWithGoogle(vc: UIViewController?) async throws -> User {
        do {
            guard let vc = vc else {
                throw AuthError.noVc
            }
            
            let user = try await GIDSignIn.sharedInstance.signIn(
                withPresenting: vc
            ).user
            
            guard let idToken = user.idToken else {
                throw AuthError.nullIdToken
            }
            
            let newCredentials = GoogleAuthProvider.credential(
                withIDToken: idToken.tokenString,
                accessToken: user.accessToken.tokenString
            )
            
            let newResult = try await authenticator.signIn(with: newCredentials)
            
            return newResult.user
        } catch {
            throw error
        }
    }
    
    private func linkWithEmailPassword() {
        //GIDSignIn.sharedInstance.
        //authenticator.sign
    }
}

enum AuthError: Error {
    case noVc
    case nullIdToken
    case googleTokenExpired
}
