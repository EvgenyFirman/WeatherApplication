//
//  MainScreenInteractor.swift
//  WeatherApp
//
//  Created by Евгений Фирман on 08.05.2023.
//

import Foundation
import RealmSwift

protocol MainScreenInteractorProtocol {
    func fetchItemsFromRealm()
}

final class MainScreenInteractor: MainScreenInteractorProtocol {
    
    let realmManager = RealmManager.shared
    private let presenter: MainScreenPresenterProtocol

    // MARK: - Init
    init(presenter: MainScreenPresenterProtocol) {
        self.presenter = presenter
    }
    
    func fetchItemsFromRealm(){
        guard let objects = realmManager.objects(WeatherRealmData.self) else {return}
        presenter.fetchItemsFromRealm(objects: objects)
    }
}
