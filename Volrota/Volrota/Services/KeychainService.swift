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
}

extension String {
    static let emailKeychainKey = "emailKeychainKey"
    static let passwordKeychainKey = "passwordKeychainKey"
}
