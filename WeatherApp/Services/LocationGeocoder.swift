//
//  LocationGeocoder.swift
//  WeatherApp
//
//  Created by kluv on 19/08/2020.
//  Copyright © 2020 com.kluv.weatherapp. All rights reserved.
//

import Foundation
import CoreLocation

class LocationGeocoder {
    
    private lazy var geocoder = CLGeocoder()
    
    func geocode(locationName: String, callback: @escaping ([Location], Error?) -> ()) {
        
        geocoder.geocodeAddressString(locationName) { (placemarks, error) in
            
            var locations: [Location] = []
            
            if let error = error {
                print("Geocoding error: (\(error.localizedDescription))")
                callback(locations,error)
            } else {
                if let placemarks = placemarks {
                    locations = placemarks.compactMap({ (placemark) -> Location? in
                        guard let name = placemark.locality, let location = placemark.location else { return nil }
                        let region = placemark.administrativeArea ?? ""
                        let fullName = "\(name), \(region)"
                        
                        return Location(name: fullName, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                    })
                }
            }
            
            callback(locations,error)
        }
    }
}
