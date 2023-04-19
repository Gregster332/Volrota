//
//  CLLocation+Extension.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/20/23.
//

import CoreLocation

extension CLLocation {
    func placeData() async throws -> CLPlacemark? {
        do {
            let placemark = try await CLGeocoder().reverseGeocodeLocation(self)
            if let placemark = placemark.first {
                return placemark
            }
        } catch {
            throw error
        }
        return nil
    }
    
    func fetchPlaceFullName() -> CLPlacemark? {
        var placemark: CLPlacemark? = nil
        let semaphore = DispatchSemaphore(value: 0)
        
        CLGeocoder().reverseGeocodeLocation(self) { placemarks, error in
            if let first = placemarks?.first, error == nil {
                placemark = first
                semaphore.signal()
            }
        }
        
        semaphore.wait()
        
        return placemark
    }
}
