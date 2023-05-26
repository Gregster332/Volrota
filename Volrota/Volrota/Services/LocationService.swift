//
//  LocationService.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/20/23.
//

import CoreLocation
import GeneralServices

protocol LocationService: AnyObject {
    
    var locationCompletion: ((CLLocation?) -> Void)? { get set }
    func getUserLocation() async -> CLLocation?
    func getUserLocation(completion: @escaping (CLLocation?) -> Void)
    func fetchCityAndCountry(location: CLLocation) async throws -> (String, String)
    func fetchCityName(location: CLLocation?) async throws -> String?
    func getFullPlacemark(location: CLLocation) async -> CLPlacemark?
    func findLocation(by query: String, completion: @escaping ([LocationModel]) -> Void)
}

final class DefaultLocationService: NSObject, LocationService, CLLocationManagerDelegate {
    
    private let locationService: CLLocationManager
    
    var locationCompletion: ((CLLocation?) -> Void)?
    
    override init() {
        locationService = CLLocationManager()
        super.init()
        locationService.delegate = self
    }
    
    func getUserLocation() async -> CLLocation? {
        return try? await withCheckedThrowingContinuation { continiation in
            
            var nilableContinuation: CheckedContinuation<CLLocation?, Error>? = continiation
            
            getUserLocation { location in
                if let location = location {
                    nilableContinuation?.resume(returning: location)
                    nilableContinuation = nil
                } else {
                    nilableContinuation?.resume(returning: nil)
                    nilableContinuation = nil
                }
            }
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
        locationService.stopUpdatingLocation()
    }
    
    func fetchCityAndCountry(location: CLLocation) async throws -> (String, String) {
        do {
            return try await withCheckedThrowingContinuation({ continuation in
                
                var nilableContinuation: CheckedContinuation<(String, String), Error>? = continuation
                
                fetchCityAndCountry(location: location) { city, placeName, error in
                    if let error = error {
                        nilableContinuation?.resume(throwing: error)
                        nilableContinuation = nil
                    }
                    if let city = city, let placeName = placeName {
                        nilableContinuation?.resume(returning: (city, placeName))
                        nilableContinuation = nil
                    }
                }
            })
        } catch {
            throw error
        }
    }
    
    func fetchCityName(location: CLLocation?) async throws -> String? {
        do {
            return try await withCheckedThrowingContinuation { continuation in
                
                var nilableContinuation: CheckedContinuation<String?, Error>? = continuation
                if let location = location {
                    fetchCityAndCountry(location: location) { city, _, error in
                        if let error = error {
                            nilableContinuation?.resume(throwing: error)
                            nilableContinuation = nil
                        }
                        if let city = city {
                            nilableContinuation?.resume(returning: city)
                            nilableContinuation = nil
                        }
                    }
                } else {
                    nilableContinuation?.resume(returning: nil)
                }
            }
        } catch {
            throw error
        }
    }
    
    func getUserLocation(completion: @escaping (CLLocation?) -> Void) {
        self.locationCompletion = completion
        
        if locationService.authorizationStatus == .denied {
            completion(nil)
            return
        }
        
        locationService.desiredAccuracy = kCLLocationAccuracyBest
        locationService.startUpdatingLocation()
    }
    
    private func fetchCityAndCountry(location: CLLocation, completion: @escaping (_ city: String?, _ placeName:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) {
            completion(
                $0?.first?.locality,
                $0?.first?.name,
                $1
            )
        }
    }
    
    func getFullPlacemark(location: CLLocation) async -> CLPlacemark? {
        let loc = try? await CLGeocoder().reverseGeocodeLocation(location)
        return loc?.first
    }
    
    func findLocation(by query: String, completion: @escaping ([LocationModel]) -> Void) {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(query) { places, error in
            guard let places = places, error == nil else {
                completion([])
                return
            }
            
            let models = places.compactMap {
                
                var placeName = ""
                
                if let locationName = $0.name {
                    placeName += locationName
                }
                
                if let region = $0.administrativeArea {
                    placeName += ", \(region)"
                }
                
                if let locality = $0.locality {
                    placeName += ", \(locality)"
                }
                
                if let country = $0.country {
                    placeName += ", \(country)"
                }
                
                return LocationModel(
                    title: placeName,
                    coordinates: $0.location?.coordinate)
            }
            
            completion(models)
        }
    }
}
