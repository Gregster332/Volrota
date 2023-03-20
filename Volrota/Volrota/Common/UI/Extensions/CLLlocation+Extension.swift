//
//  CLLlocation+Extension.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/20/23.
//

import Foundation
import CoreLocation

extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.name, $0?.first?.country, $1) }
    }
    
    func fetchCityAndCountry() async throws -> String {
        do {
            return try await withCheckedThrowingContinuation({ continuation in
                
                var nilableContinuation: CheckedContinuation<String, Error>? = continuation
                
                fetchCityAndCountry { city, country, error in
                    if let error = error {
                        nilableContinuation?.resume(throwing: error)
                        nilableContinuation = nil
                    }
                    if let city = city {
                        nilableContinuation?.resume(returning: city)
                        nilableContinuation = nil
                    }
                }
            })
        } catch {
            throw error
        }
    }
}
