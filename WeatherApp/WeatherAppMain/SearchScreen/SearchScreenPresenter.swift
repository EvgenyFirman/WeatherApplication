//
//  SearchScreenPresenter.swift
//  WeatherApp
//
//  Created by Евгений Фирман on 08.05.2023.
//

protocol SearchScreenPresenterProtocol {
    func displayCityGeolocationByName(weatherData: WeatherData)
    func showError(error: Error)
}

final class SearchScreenPresenter: SearchScreenPresenterProtocol {
    
    // MARK: - Properties
    weak var viewController: SearchScreenDisplayProtocol?
    
    func displayCityGeolocationByName(weatherData: WeatherData) {
        viewController?.displayGeoLocationCityByName(weatherData: weatherData)
    }

    func showError(error: Error) {
        viewController?.showError(error: error)
    }
}
