//
//  AuthService.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/31/23.
//

import FirebaseAuth

protocol AuthService {
    var currentUser: User? { get }
    func signIn(_ email: String, _ password: String) async throws -> String
    func register(with email: String, _ password: String) async throws -> User
    func logOut()
}

final class DefaultAuthService: AuthService {
    
    private let authenticator: Auth
    
    var currentUser: User? {
        return authenticator.currentUser
    }
    
    init() {
        authenticator = Auth.auth()
    }
    
    func signIn(_ email: String, _ password: String) async throws -> String {
        do {
            let result = try await authenticator.signIn(withEmail: email, password: password)
            return result.user.uid
        } catch {
            throw error
        }
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
}
