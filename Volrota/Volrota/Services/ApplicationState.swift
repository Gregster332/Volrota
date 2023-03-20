import Foundation

protocol ApplicationState {
    var isOnboardingCompleted: Bool { get set }
}

final class UserDefaultsApplicationState: ApplicationState {
    
    var isOnboardingCompleted: Bool {
        get { UserDefaults.standard.bool(forKey: .onboardingCompleted) }
        set { UserDefaults.standard.set(newValue, forKey: .onboardingCompleted) }
    }
}

// MARK: - UserDefaults Keys
fileprivate extension String {
    static let onboardingCompleted = "isOnboardingCompleted"
}
