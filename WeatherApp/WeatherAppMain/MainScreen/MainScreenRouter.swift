//
//  MainScreenRouter.swift
//  WeatherApp
//
//  Created by Евгений Фирман on 08.05.2023.
//

import UIKit

enum MainScreenRouterIdentifiers {
    case searchScreen
}

final class MainScreenRouter  {
 
    func route(to routeID: MainScreenRouterIdentifiers, from context: UIViewController) {
        switch routeID {
        case .searchScreen:
            let vc = SearchScreenFactory.makeModule()
            vc.modalPresentationStyle = .fullScreen
            context.present(vc,animated: true)
        }
    }
}

