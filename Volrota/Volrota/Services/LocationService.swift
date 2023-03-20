//
//  LocationService.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/20/23.
//

import Foundation
import CoreLocation

protocol LocationService: AnyObject {
    
    var locationCompletion: ((CLLocation) -> Void)? { get set }
    func getUserLocation(completion: @escaping (CLLocation) -> Void)
    func getUserLocation() async throws -> CLLocation
}

final class DefaultLocationService: NSObject, LocationService, CLLocationManagerDelegate {
    
    private let locationService: CLLocationManager
    
    var locationCompletion: ((CLLocation) -> Void)?
    
    override init() {
        locationService = CLLocationManager()
        super.init()
        locationService.delegate = self
    }
    
    func getUserLocation(completion: @escaping (CLLocation) -> Void) {
        self.locationCompletion = completion
        locationService.desiredAccuracy = kCLLocationAccuracyBest
        locationService.startUpdatingLocation()
    }
    
    func getUserLocation() async throws -> CLLocation {
        do {
            return try await withCheckedThrowingContinuation { continiation in
                
                var nilableContinuation: CheckedContinuation<CLLocation, Error>? = continiation
                
                getUserLocation { location in
                    if location.coordinate.latitude == 0 || location.coordinate.longitude == 0 {
                        //continiation = nil
                        nilableContinuation?.resume(throwing: LocationError.someError)
                        nilableContinuation = nil
                    }
                    //continiation = nil
                    nilableContinuation?.resume(returning: location)
                    nilableContinuation = nil
                }
            }
        } catch {
            throw error
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.first else {
            return
        }
        locationCompletion?(location)
    }
}

enum LocationError: Error {
    case someError
}
