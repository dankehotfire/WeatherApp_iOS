//
//  ViewController.swift
//  MyWeather
//
//  Created by Danil Nurgaliev on 20.05.2021.
//

import UIKit

import CoreLocation

class ViewController: UIViewController {
    private var latitude: CLLocationDegrees?
    private var longitude: CLLocationDegrees?
    private var networkWeatherManager = NetworkWeatherManager()

    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        return locationManager
    }()

    @IBOutlet private weak var cityName: UILabel!
    @IBOutlet private weak var temperatureValue: UILabel!
    @IBOutlet private weak var feelsLikeValue: UILabel!
    @IBOutlet private weak var humidityValue: UILabel!
    @IBOutlet private weak var windValue: UILabel!
    @IBOutlet private weak var conditionView: UIImageView!
    @IBOutlet weak var weatherDescription: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 60 / 255, green: 137 / 255, blue: 181 / 255, alpha: 1)

        networkWeatherManager.delegate = self

        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
    }

    @IBAction private func searchButtonPressed(_ sender: UIButton) {
        self.presentSearchAlertController(title: "Enter city name", message: nil) { city in
            self.networkWeatherManager.getCurrentWeather(forRequestType: .cityName(city: city))
        }
    }

    @IBAction private func locationButtonPressed(_ sender: UIButton) {
        guard let latitude = latitude, let longitude = longitude else {
            return
        }

        networkWeatherManager.getCurrentWeather(forRequestType: .coordinate(latitude: latitude, longitude: longitude))
    }
}

extension ViewController: NetworkWeatherManagerDelegate {
    func updateInformation(currentWeather: CurrentWeather) {
        DispatchQueue.main.async {
            self.cityName.text = currentWeather.cityName
            self.temperatureValue.text = currentWeather.temperatureString + "°"
            self.feelsLikeValue.text = "Feels like: \(currentWeather.feelsLikeTempString)°"
            self.humidityValue.text = "Humidity: \(currentWeather.humidity) %"
            self.windValue.text = "Wind: \(currentWeather.windSpeed) m/s"
            self.conditionView.image = UIImage(systemName: currentWeather.systemIconNameString)
            self.conditionView.tintColor = UIColor.white
            self.weatherDescription.text = currentWeather.weatherDescription
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last

        guard let latitude = location?.coordinate.latitude, let longitude = location?.coordinate.longitude else {
            return
        }

        networkWeatherManager.getCurrentWeather(forRequestType: .coordinate(latitude: latitude, longitude: longitude))
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        assertionFailure("\(error)")
    }
}
