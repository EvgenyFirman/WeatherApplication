//
//  MainScreenViewController.swift
//  WeatherApp
//
//  Created by Евгений Фирман on 08.05.2023.
//

import UIKit
import SnapKit
import RealmSwift

protocol MainScreenDisplayProtocol: AnyObject {
    func fetchItemsFromRealm(objects: Results<WeatherRealmData>)
}

class MainScreenViewController: UIViewController {
    
    //MARK: - UIElements
    var weatherIV: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    var blackOverlay: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.opacity = 0.5
        return view
    }()
    
    var navBar: UINavigationBar = {
        let navBar = UINavigationBar()
        return navBar
    }()
    
    var searchButton: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(systemName: "magnifyingglass.circle.fill"), for: .normal)
        btn.addTarget(nil, action: #selector(searchButtonPressed), for: .touchUpInside)
        btn.tintColor = .white
        return btn
    }()
    
    var mainScreenCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.isPagingEnabled = true
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.register(MainScreenCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()
    
    private let interactor: MainScreenInteractorProtocol
    let router = MainScreenRouter()
    let realmManager = RealmManager.shared
    var cityRealm: Results<WeatherRealmData>?
    
    // MARK: - Init
    init(interactor: MainScreenInteractorProtocol) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        interactor.fetchItemsFromRealm()
    }
    
    func checkWeatherImageView(num: Int){
        guard let weatherID = cityRealm?[num].weatherID else {return}
        switch weatherID {
        case 200...232:
            weatherIV.image = UIImage(named: "sunnyWeather.png")
        case 300...321:
            weatherIV.image = UIImage(named: "cloudyWeather.png")
        case 500...531:
            weatherIV.image = UIImage(named: "cloudyWeather.png")
        case 600...622:
            weatherIV.image = UIImage(named: "winterWeather.png")
        case 701...781:
            weatherIV.image = UIImage(named: "cloudyWeather.png")
        case 800:
            weatherIV.image = UIImage(named: "sunnyWeather.png")
        case 801...804:
            weatherIV.image = UIImage(named: "cloudyWeather.png")
        default:
            weatherIV.image = UIImage(named: "cloudyWeather.png")
        }
    }
    
}

//MARK: - Extension for UIElements

extension MainScreenViewController {
    
    private func configureVC(){
        view.backgroundColor = .white
        self.setupHideKeyboardOnTap()
        mainScreenCollectionView.delegate = self
        mainScreenCollectionView.dataSource = self
    }
    
    private func configureViews(){
        [weatherIV,
         blackOverlay,
         navBar,
         mainScreenCollectionView
        ].forEach { view.addSubview($0)}
        [searchButton].forEach { navBar.addSubview($0)}
    }
    
    private func configureConstraints(){
        weatherIV.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        blackOverlay.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        navBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(100)
        }
        searchButton.snp.makeConstraints { make in
            make.bottom.equalTo(navBar.snp.bottom)
            make.right.equalTo(navBar.snp.right).inset(20)
            make.height.width.equalTo(40)
        }
        mainScreenCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.navBar.snp.bottom).offset(20)
            make.bottom.equalToSuperview()
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
        }
    }
}

//MARK: - OBJC Methods
extension MainScreenViewController {
    
    @objc func searchButtonPressed(){
        router.route(to: .searchScreen, from: self)
    }
}

extension MainScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cityRealm?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MainScreenCollectionViewCell else {return UICollectionViewCell()}
        cell.cityLabel.text = cityRealm?[indexPath.row].name
        cell.tempLabel.text = "Тemperature \(String(format: "%.0f", cityRealm?[indexPath.row].temp ?? 0))°"
        cell.humidityLabel.text = "Humidity: \(String(cityRealm?[indexPath.row].humidity ?? 0)) %"
        return cell

    }
}

//MARK: - UICollectionView DelegateFlowLayout
extension MainScreenViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        let currentPage = Int(ceil(x/w))
        checkWeatherImageView(num: currentPage)
    }
}

//MARK: - Main Screen Display Protocol
extension MainScreenViewController: MainScreenDisplayProtocol {
    
    func fetchItemsFromRealm(objects: Results<WeatherRealmData>) {
        cityRealm = objects
        if cityRealm?.count == 0 {
            self.mainScreenCollectionView.reloadData()
        } else {
            checkWeatherImageView(num: 0)
            self.mainScreenCollectionView.reloadData()
        }
    }
}


