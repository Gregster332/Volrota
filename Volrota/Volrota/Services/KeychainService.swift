//
//  KeychainService.swift
//  Volrota
//
//  Created by Greg Zenkov on 4/1/23.
//

import KeychainAccess

protocol KeychainService {
    var userEmail: String? { get set }
    var userPassword: String? { get set }
    var userGoogleIdToken: String? { get set }
    var userGoogleAccessToken: String? { get set }
    
    func clear(completion: @escaping () -> Void)
}

final class DefaultKeychainService: KeychainService {
    
    private let keyChain: Keychain
    
    init() {
        keyChain = Keychain(service: "com.jqsoftware.Volrota")
    }
    
    var userEmail: String? {
        get { try? keyChain.get(.emailKeychainKey) }
        set { try? keyChain.set(newValue ?? "", key: .emailKeychainKey) }
    }
    
    var userPassword: String? {
        get { try? keyChain.get(.passwordKeychainKey) }
        set { try? keyChain.set(newValue ?? "", key: .passwordKeychainKey) }
    }
    
    var userGoogleIdToken: String? {
        get { try? keyChain.get(.userGoogleIdToken) }
        set { try? keyChain.set(newValue ?? "", key: .userGoogleIdToken) }
    }
    
    var userGoogleAccessToken: String? {
        get { try? keyChain.get(.userGoogleAccessToken) }
        set { try? keyChain.set(newValue ?? "", key: .userGoogleAccessToken) }
    }
    
    func clear(completion: @escaping () -> Void) {
        userEmail = nil
        userPassword = nil
        userGoogleIdToken = nil
        userGoogleAccessToken = nil
        completion()
    }
}

extension String {
    static let emailKeychainKey = "emailKeychainKey"
    static let passwordKeychainKey = "passwordKeychainKey"
    static let userGoogleIdToken = "userGoogleIdToken"
    static let userGoogleAccessToken = "userGoogleAccessToken"
}
