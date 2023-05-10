//
//  SearchScreenFactory.swift
//  WeatherApp
//
//  Created by Евгений Фирман on 08.05.2023.
//

import UIKit

struct SearchScreenFactory {
    
    static func makeModule() -> SearchScreenViewController {
        let presenter = SearchScreenPresenter()
        let interactor = SearchScreenInteractor(presenter: presenter)
        let viewController = SearchScreenViewController(interactor: interactor)
        presenter.viewController = viewController
        return viewController
    }
}
