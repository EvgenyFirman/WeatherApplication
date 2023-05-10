//
//  MainScreenCollectionViewCells.swift
//  WeatherApp
//
//  Created by Евгений Фирман on 08.05.2023.
//

import UIKit
import SnapKit

class MainScreenCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Variables
    
    let cityLabel: UILabel = {
        let label = UILabel()
        label.text = "Перейдите к поиску города"
        label.font = UIFont.systemFont(ofSize: 35)
        label.numberOfLines = 0
        return label
    }()
    let tempLabel: UILabel = {
        let label = UILabel()
        label.text = "23 C"
        label.font = UIFont.systemFont(ofSize: 25)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    let humidityLabel: UILabel = {
        let label = UILabel()
        label.text = "50%"
        label.font = UIFont.systemFont(ofSize: 25)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        configViews()
        configConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - MainScreenCollectionViewCell UI Configuration
extension MainScreenCollectionViewCell {
    
    func configViews(){
        contentView.backgroundColor = .clear
        [cityLabel,
         tempLabel,
         humidityLabel,
        ].forEach { contentView.addSubview($0)}
    }
    
    func configConstraints(){
        cityLabel.snp.makeConstraints { make in
            make.top.equalTo(self.contentView.snp.top).offset(30)
            make.centerX.equalTo(self.contentView.snp.centerX)
        }
        tempLabel.snp.makeConstraints { make in
            make.top.equalTo(self.cityLabel.snp.bottom).offset(20)
            make.centerX.equalTo(self.contentView.snp.centerX)
        }
        humidityLabel.snp.makeConstraints { make in
            make.top.equalTo(self.tempLabel.snp.bottom).offset(20)
            make.centerX.equalTo(self.contentView.snp.centerX)
        }
    }
}

