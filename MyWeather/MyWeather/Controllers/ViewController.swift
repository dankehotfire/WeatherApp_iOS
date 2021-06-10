//
//  ViewController.swift
//  MyWeather
//
//  Created by Danil Nurgaliev on 20.05.2021.
//

import CoreLocation
import UIKit

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
            assertionFailure("no latitude no longitude")
            return
        }

        networkWeatherManager.getCurrentWeather(forRequestType: .coordinate(latitude: latitude, longitude: longitude))
    }

    private func presentSearchAlertController(title: String?, message: String?, completionHandler: @escaping (String) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField { textField in
            let cities = ["Kazan", "Minsk", "Moscow", "Stambul", "New York"]
            textField.placeholder = cities.randomElement()
        }

        let search = UIAlertAction(title: "Search", style: .default) { _ in
            let textfield = alertController.textFields?.first
            guard  let cityName = textfield?.text else {
                return
            }

            if !cityName.isEmpty {
                let city = cityName.split(separator: " ").joined(separator: "%20")
                completionHandler(city)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)

        alertController.addAction(cancel)
        alertController.addAction(search)
        present(alertController, animated: true, completion: nil)
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

        latitude = location?.coordinate.latitude
        longitude = location?.coordinate.longitude

        guard let latitude = latitude, let longitude = longitude else {
            assertionFailure("no latitude no longitude")
            return
        }

        networkWeatherManager.getCurrentWeather(forRequestType: .coordinate(latitude: latitude, longitude: longitude))
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        assertionFailure("\(error)")
    }
}
