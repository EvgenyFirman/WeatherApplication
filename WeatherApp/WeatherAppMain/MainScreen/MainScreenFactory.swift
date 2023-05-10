//
//  MainScreenFactory.swift
//  WeatherApp
//
//  Created by Евгений Фирман on 08.05.2023.
//

import UIKit

struct MainScreenFactory {
    
    static func makeModule() -> MainScreenViewController {
        let presenter = MainScreenPresenter()
        let interactor = MainScreenInteractor(presenter: presenter)
        let viewController = MainScreenViewController(interactor: interactor)
        presenter.viewController = viewController
        return viewController
    }
}

