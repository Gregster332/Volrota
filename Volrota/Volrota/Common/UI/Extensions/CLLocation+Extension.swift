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
}
