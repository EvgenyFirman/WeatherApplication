//
//  MainScreenPresenter.swift
//  WeatherApp
//
//  Created by Евгений Фирман on 08.05.2023.
//

import Foundation
import RealmSwift

protocol MainScreenPresenterProtocol {
    func fetchItemsFromRealm(objects: Results<WeatherRealmData>)
}

final class MainScreenPresenter: MainScreenPresenterProtocol {
    
    // MARK: - Properties
    weak var viewController: MainScreenDisplayProtocol?

    func fetchItemsFromRealm(objects: Results<WeatherRealmData>){
        viewController?.fetchItemsFromRealm(objects: objects)
    }
}
