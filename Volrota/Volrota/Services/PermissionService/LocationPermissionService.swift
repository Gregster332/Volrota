//
//  LocationPermissionService.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/20/23.
//

import Foundation
import CoreLocation

final class LocationPermissionService: PermissionService {
    
    private let locationManager: CLLocationManager
    
    init() {
        locationManager = CLLocationManager()
    }
    
    func isGrantedAccess() async -> Bool {
        locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse
    }
    
    func request() async -> PermissionStatus {
        locationManager.requestWhenInUseAuthorization()
        if locationManager.authorizationStatus != .denied {
            return .authorized
        }
        return .denied
    }
}
