//
//  Location.swift
//  WeatherApp
//
//  Created by kluv on 19/08/2020.
//  Copyright © 2020 com.kluv.weatherapp. All rights reserved.
//

import Foundation
import CoreLocation

struct Location {
    let name: String
    let latitude: Double
    let longitude: Double
    
    var location: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}

extension Location: Equatable {
    static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.name == rhs.name &&
            lhs.latitude == rhs.latitude &&
            lhs.longitude == rhs.longitude
    }
}
