//
//  WeatherInfo.swift
//  WeatherApp
//
//  Created by Евгений Фирман on 08.05.2023.
//

import Foundation


struct WeatherInfo {
    var weatherID: Int?
    var name: String?
    var temp: Double?
    var humidity: Int?
    
    init(
        weatherID: Int? = nil,
        name: String? = nil,
        temp: Double? = nil,
        humidity: Int? = nil
    ) {
            self.weatherID = weatherID
            self.name = name
            self.temp = temp
            self.humidity = humidity
    }
}
