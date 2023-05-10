//
//  HistorySearchTableViewCell.swift
//  WeatherApp
//
//  Created by Евгений Фирман on 08.05.2023.
//

import UIKit
import RealmSwift


//MARK: - WeatherMainTableViewCell
class HistorySearchTableViewCell: UITableViewCell {
    
    //MARK: - UIElements
    var cityInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Petrozavodsk"
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        return label
    }()
    var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить", for: .normal)
        button.titleLabel?.textAlignment = .right
        button.backgroundColor = .red
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(nil, action: #selector(addButtonPressed), for: .touchUpInside)
        return button
    }()
    var weatherInfo: WeatherInfo?
    let realmManager = RealmManager.shared
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        configureViews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Initialze Weather Info
    func initializeWeatherInfo(
        weatherId: Int,
        name: String,
        temp: Double,
        humidity: Int){
        weatherInfo = WeatherInfo(weatherID: weatherId,
                                  name: name,
                                  temp: temp,
                                  humidity: humidity)
    }
    
    //MARK: - Add data about city to realm
    @objc func addButtonPressed(){
        let weatherRealmData = WeatherRealmData()
        guard let weatherId = weatherInfo?.weatherID else {return}
        guard let name = weatherInfo?.name else {return}
        guard let temp = weatherInfo?.temp else {return}
        guard let humidity = weatherInfo?.humidity else {return}
        weatherRealmData.weatherID = weatherId
        weatherRealmData.name = name
        weatherRealmData.temp = temp
        weatherRealmData.humidity = humidity
        addButton.setTitle("Добавлено", for: .normal)
        addButton.backgroundColor = .gray
        addButton.isUserInteractionEnabled = false
        realmManager.add(weatherRealmData)
    }
    
}

extension HistorySearchTableViewCell {
    
    func configureViews(){
        [cityInfoLabel,
         addButton
        ].forEach { contentView.addSubview($0)}
    }
    
    func configureConstraints(){
        cityInfoLabel.snp.makeConstraints { cityInfoLabel in
            cityInfoLabel.left.equalTo(self.contentView.snp.left).offset(25)
            cityInfoLabel.centerY.equalTo(self.contentView.snp.centerY)
        }
        
        addButton.snp.makeConstraints { listButton in
            listButton.right.equalTo(self.contentView.snp.right).inset(25)
            listButton.centerY.equalTo(self.contentView.snp.centerY)
            listButton.width.equalTo(100)
            listButton.height.equalTo(35)
        }
    }
}
