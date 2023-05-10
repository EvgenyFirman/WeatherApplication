//
//  WeatherDataRealm.swift
//  WeatherApp
//
//  Created by Евгений Фирман on 08.05.2023.
//

import Foundation
import RealmSwift


class WeatherRealmData: Object {
    @objc dynamic var weatherID: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var temp: Double = 0.0
    @objc dynamic var humidity: Int = 0
}
