//
//  SearchScreenViewController.swift
//  WeatherApp
//
//  Created by Евгений Фирман on 08.05.2023.
//

import UIKit

protocol SearchScreenDisplayProtocol: AnyObject {
    func displayGeoLocationCityByName(weatherData: WeatherData)
    func showError(error: Error)
}

class SearchScreenViewController: UIViewController {
    
    //MARK: - UIElements
    let backBTN: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(nil, action: #selector(backButtonPressed), for: .touchUpInside)
        button.tintColor = .black
        return button
    }()
    
    var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.barTintColor = .systemGray6
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.leftView?.tintColor = .black
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        
        textFieldInsideSearchBar?.textColor = .black
        return searchBar
    }()
    
    var historySearchTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self,forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let interactor: SearchScreenInteractorProtocol
    var cityArray = [WeatherData]()
    let realmManager = RealmManager.shared
    
    // MARK: - Init
    init(interactor: SearchScreenInteractorProtocol) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ViewController LifeCycle
    
    override func viewDidLoad() {
        configureVC()
        configureViews()
        configureConstraints()
    }
    
}

//MARK: - Extension for UIElements

extension SearchScreenViewController {
    
    private func configureVC(){
        view.backgroundColor = .white
        historySearchTableView.delegate = self
        historySearchTableView.dataSource = self
        historySearchTableView.register(HistorySearchTableViewCell.self, forCellReuseIdentifier: "cell")
        searchBar.delegate = self
        setupHideKeyboardOnTap()
    }
    
    
    private func configureViews(){
        [backBTN,searchBar,historySearchTableView].forEach { view.addSubview($0)}
       
    }
    
    private func configureConstraints(){
            
        backBTN.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp.top).offset(60)
            make.left.equalTo(self.view.snp.left).offset(32)
            make.width.equalTo(26)
            make.height.equalTo(28)
        }
        
        searchBar.snp.makeConstraints { searchBar in
            searchBar.top.equalTo(self.backBTN.snp.bottom).offset(40)
            searchBar.left.equalTo(self.view.snp.left).offset(15)
            searchBar.right.equalTo(self.view.snp.right).inset(15)
            searchBar.height.equalTo(40)
        }
        
        historySearchTableView.snp.makeConstraints { historySearchTableView in
            historySearchTableView.top.equalTo(self.searchBar.snp.bottom).offset(10)
            historySearchTableView.left.equalTo(self.view.snp.left)
            historySearchTableView.right.equalTo(self.view.snp.right)
            historySearchTableView.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
       
    }
}

//MARK: - OBJC Methods
extension SearchScreenViewController {
    
    @objc func backButtonPressed(){
        self.dismiss(animated: true)
    }
    
}

//MARK: - Extension for TableView
extension SearchScreenViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? HistorySearchTableViewCell else {return UITableViewCell()}
        let cityInfo = cityArray[indexPath.row]
        cell.cityInfoLabel.text = cityInfo.name
        cell.initializeWeatherInfo(
            weatherId: cityInfo.weather?[0].id ?? 0,
            name: cityInfo.name ?? "",
            temp: cityInfo.main?.temp ?? 0,
            humidity: cityInfo.main?.humidity ?? 0)
        return cell
    }
}

//MARK: - Search Screen Display Protocol
extension SearchScreenViewController: SearchScreenDisplayProtocol {
    
    // - Show info about city
    func displayGeoLocationCityByName(weatherData: WeatherData) {
        cityArray.append(weatherData)
        searchBar.text = nil
        self.historySearchTableView.reloadData()
    }
    
    // - Show Error if request failed
    func showError(error: Error) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: "\(error.localizedDescription)", preferredStyle: UIAlertController.Style.alert
        )
        alert.addAction(UIAlertAction(title: "Понятно", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: - WeatherMainViewController
extension SearchScreenViewController: UISearchBarDelegate {
    
    // - Request sended
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        let tempState: String = "metric"
        guard let cityName = searchBar.text else {return}
        interactor.getCityGeolocationByName(name: cityName, tempState: tempState)
    }
}
