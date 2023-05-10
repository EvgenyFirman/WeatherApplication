//
//  SearchScreenInteractor.swift
//  WeatherApp
//
//  Created by Евгений Фирман on 08.05.2023.
//

import Foundation

protocol SearchScreenInteractorProtocol {
    func getCityGeolocationByName(name: String, tempState: String)
}

final class SearchScreenInteractor: SearchScreenInteractorProtocol {
  
    private let networkManager = NetworkManager()
    private let presenter: SearchScreenPresenterProtocol

    // MARK: - Init
    init(presenter: SearchScreenPresenterProtocol) {
        self.presenter = presenter
    }
    
    func getCityGeolocationByName(name: String, tempState: String) {
        networkManager.getCityGeolocationByName(name: name,tempState: tempState) { result in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(let result):
                    self?.presenter.displayCityGeolocationByName(weatherData: result)
                case .failure(let error):
                    self?.presenter.showError(error: error)
                    break
                }
            }
        }
    }
    
}
