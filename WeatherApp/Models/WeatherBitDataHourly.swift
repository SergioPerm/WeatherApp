//
//  WeatherBitDataHourly.swift
//  WeatherApp
//
//  Created by kluv on 19/08/2020.
//  Copyright © 2020 com.kluv.weatherapp. All rights reserved.
//

import Foundation

struct WeatherBitDataHourly: Decodable {
    
    let hours: [Hours]
    
    struct Hours: Decodable {
        let temp: Double
        let datetime: String
        let time: Int
        let timeStamp: String
        let weather: Weather
        
        enum CodingKeys: String, CodingKey {
            case temp
            case datetime
            case weather
            case timeStamp = "timestamp_local"
        }
        
        struct Weather: Decodable {
            let icon: String
            let description: String
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case hours = "data"
    }
}

typealias Hours = WeatherBitDataHourly.Hours

extension Hours {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        temp = try container.decode(Double.self, forKey: .temp)
        weather = try container.decode(Weather.self, forKey: .weather)
        timeStamp = try container.decode(String.self, forKey: .timeStamp)
        datetime = try container.decode(String.self, forKey: .datetime)
        let formatter = DateFormatter.yyyyMMddH
        if let date = formatter.date(from: timeStamp) {
            var calendar = Calendar.current
            calendar.timeZone = TimeZone(secondsFromGMT: 0)!
            time = calendar.component(.hour, from: date)
        } else {
            throw DecodingError.dataCorruptedError(forKey: .datetime, in: container, debugDescription: "Date string does not match format expected by formatter.")
        }
    }
}

extension DateFormatter {

    static let yyyyMMddH: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "es")
        return formatter
    }()

}
