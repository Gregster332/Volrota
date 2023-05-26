//
//  FirebaseRemoteConfig.swift
//  GeneralServices
//
//  Created by Greg Zenkov on 5/14/23.
//

import Firebase

public protocol FirebaseRemoteConfig: AnyObject {
    var onboardingVersion: OnboardingVersion { get set }
    
    func load() async
}

public final class FirebaseRemoteConfigImpl: FirebaseRemoteConfig {
    
    public var onboardingVersion: OnboardingVersion = .v1_1
    
    public init() {
        Task {
            await load()
        }
    }
    
    public func load() async {
        guard await fetchRemoteConfig(),
              await fetchAndActivateRemoteConfig(),
              let onboarding = RemoteConfig.remoteConfig().configValue(forKey: .onboarding).stringValue,
        let onboardingVersion = OnboardingVersion(rawValue: onboarding) else {
            return
        }
        self.onboardingVersion = onboardingVersion
    }
    
    private func fetchRemoteConfig() async -> Bool {
        await withCheckedContinuation { continuation in
            RemoteConfig.remoteConfig().fetch(withExpirationDuration: 0) { status, _ in
                continuation.resume(returning: status == .success)
            }
        }
    }
    
    private func fetchAndActivateRemoteConfig() async -> Bool {
        await withCheckedContinuation { continuation in
            RemoteConfig.remoteConfig().fetchAndActivate { status, _ in
                continuation.resume(returning: status == .successFetchedFromRemote)
            }
        }
    }
}

fileprivate extension String {
    static let onboarding = "onboarding"
}
