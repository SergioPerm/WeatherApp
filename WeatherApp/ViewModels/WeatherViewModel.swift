//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by kluv on 19/08/2020.
//  Copyright © 2020 com.kluv.weatherapp. All rights reserved.
//

import Foundation

public class WeatherViewModel {
    
    static let defaultAddress = "Perm"
    
    private let geocoder = LocationGeocoder()
    private let emptyDays: [Days] = []
    private let emptyHours: [Hours] = []
    
    var cityName = Boxing("...loading")
    var forecast: Boxing<(weatherDays:[Days], weatherHours:[Hours])>
    
    init() {
        forecast = Boxing((emptyDays, emptyHours))
        changeLocation(to: Self.defaultAddress)
    }
    
    func changeLocation(to newLocation: String) {
        
        geocoder.geocode(locationName: newLocation) { [weak self] (locations, error) in
            
            guard let self = self else { return }
            
            guard error == nil else {
                print("Geocode error: \(error!.localizedDescription)")
                return
            }
            
            if let location = locations.first {
                self.fetchWeatherForLocation(location)
                return
            }
            
            self.forecast.value = (self.emptyDays, self.emptyHours)
            
        }
    }
    
    private func fetchWeatherForLocation(_ location: Location) {
        
        WeatherBitService.weatherDataForLocation(latitude: location.latitude, longitude: location.longitude) { [weak self] (weatherData, weatherDataHourly, error) in
            guard let self = self, let weatherData = weatherData, let weatherDataHourly = weatherDataHourly else { return }
            self.cityName.value = weatherData.cityName
            self.forecast.value = (weatherData.days, weatherDataHourly.hours)
        }
                
    }
    
}
