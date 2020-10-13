//
//  WeatherBitData.swift
//  WeatherApp
//
//  Created by kluv on 19/08/2020.
//  Copyright © 2020 com.kluv.weatherapp. All rights reserved.
//

import Foundation

struct WeatherBitData: Decodable {
    
    private static let dateFormatter: DateFormatter = {
      var formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd"
      return formatter
    }()
    
    let cityName: String
    let days: [Days]
        
    struct Days: Decodable {
        let temp: Double
        let tempString: String
        let datetime: Date
        let dateString: String
        let dayOfWeek: String
        
        let weather: Weather
        
        enum CodingKeys: String, CodingKey {
            case temp
            case datetime
            case weather
        }
        
        struct Weather: Decodable {
            let icon: String
            let description: String
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case cityName = "city_name"
        case days = "data"
    }
}

typealias Days = WeatherBitData.Days

extension Days {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        temp = try container.decode(Double.self, forKey: .temp)
        weather = try container.decode(Weather.self, forKey: .weather)
        
        dateString = try container.decode(String.self, forKey: .datetime)
        let formatter = DateFormatter.yyyyMMdd
        if let date  = formatter.date(from: dateString) {
            datetime = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .datetime, in: container, debugDescription: "Date string does not match format expected by formatter.")
        }
        
        dayOfWeek = datetime.dayOfWeek()
        
        tempString = NumberFormatter.tempFormatter.string(from: temp as NSNumber) ?? ""
    }
}

extension DateFormatter {
    
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
}

extension NumberFormatter {
    
    static let tempFormatter: NumberFormatter = {
        let tempFormatter = NumberFormatter()
        tempFormatter.numberStyle = .none
        return tempFormatter
    }()
    
}

extension Date {
    func dayOfWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
}

