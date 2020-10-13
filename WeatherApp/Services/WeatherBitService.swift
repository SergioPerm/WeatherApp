//
//  WeatherBitService.swift
//  WeatherApp
//
//  Created by kluv on 19/08/2020.
//  Copyright © 2020 com.kluv.weatherapp. All rights reserved.
//

import Foundation

enum WeatherBitError:  Error {
  case invalidResponse
  case noData
  case failedRequest
  case invalidData
}

enum WeatherTypeRequestPath: String {
    case dailyPath = "/v2.0/forecast/daily"
    case hourlyPath = "/v2.0/forecast/hourly"
}

class WeatherBitService {
    typealias WeatherDataCompletion = (WeatherBitData?, WeatherBitDataHourly?, WeatherBitError?) -> ()
    
    private static let apiKey = "febf24dea8624167bd3df4e7971de89e"
    private static let host = "api.weatherbit.io"
    private static let countDaysForecast = "8"
    private static let countHoursForecast = "24"
        
    static func weatherDataForLocation(latitude: Double, longitude: Double, completion: @escaping WeatherDataCompletion) {
        var urlBuilder = URLComponents()
        urlBuilder.scheme = "https"
        urlBuilder.host = host
        urlBuilder.path = WeatherTypeRequestPath.dailyPath.rawValue
        
        urlBuilder.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "lat", value: "\(latitude)"),
            URLQueryItem(name: "lon", value: "\(longitude)")
        ]
        
        urlBuilder.queryItems?.append(URLQueryItem(name: "days", value: countDaysForecast))

        let urlDaily = urlBuilder.url!
        //Modified for hourly url
        urlBuilder.queryItems?.removeLast()
        urlBuilder.queryItems?.append(URLQueryItem(name: "hours", value: countHoursForecast))
        urlBuilder.path = WeatherTypeRequestPath.hourlyPath.rawValue
        
        let urlHourly = urlBuilder.url!

        URLSession.shared.dataTask(with: urlDaily) { (dayData, responce, error) in
            URLSession.shared.dataTask(with: urlHourly) { (hourlyData, responce, error) in
                DispatchQueue.main.async {
                    guard let dayData = dayData else {
                        print("No data returned from Weatherbit")
                        completion(nil, nil, .noData)
                        return
                    }
      
                    guard let hourlyData = hourlyData else {
                        print("No data returned from Weatherbit")
                        completion(nil, nil, .noData)
                        return
                    }
                         
//                    do {
//                        let json = try JSONSerialization.jsonObject(with: hourlyData, options: [])
//                        print(json)
//                    } catch {
//                        print("123")
//                    }
                    
                    do {
                        let decoder = JSONDecoder()
                        let weatherData: WeatherBitData = try decoder.decode(WeatherBitData.self, from: dayData)
                        let weatherDataHourly: WeatherBitDataHourly = try decoder.decode(WeatherBitDataHourly.self, from: hourlyData)
                        completion(weatherData, weatherDataHourly, nil)
                    } catch {
                        print("Unable to decode Weatherbit response: \(error.localizedDescription)")
                    }
                }
            }.resume()
        }.resume()
    }
}
