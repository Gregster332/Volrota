import Foundation

enum PermissionStatus {
    case authorized
    case denied
    case notDetermined
    case limited
}

protocol PermissionService {
    func isGrantedAccess() async -> Bool
    func request() async -> PermissionStatus
}
