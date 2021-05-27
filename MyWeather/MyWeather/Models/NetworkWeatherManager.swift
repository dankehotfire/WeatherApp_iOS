//
//  NetworkWeatherManager.swift
//  MyWeather
//
//  Created by Danil Nurgaliev on 20.05.2021.
//

import CoreLocation
import Foundation

protocol NetworkWeatherManagerDelegate: AnyObject {
    func updateInformation(currentWeather: CurrentWeather)
}

class NetworkWeatherManager {
    enum RequestType {
        case cityName(city: String)
        case coordinate(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    }

    weak var delegate: NetworkWeatherManagerDelegate?

    func getCurrentWeather(forRequestType requestType: RequestType) {
        var urlString = ""
        switch requestType {
        case .cityName(let city):
            urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&apikey=\(apiKey)&units=metric"
        case let .coordinate(latitude, longitude):
            urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        }
        performRequest(withUrlString: urlString)
    }

    private func performRequest(withUrlString urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        let request = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, _, error  in
            if error == nil, let data = data {
                if let currentWeather = self.parseJSON(data: data) {
                    self.delegate?.updateInformation(currentWeather: currentWeather)
                }
            }
        }
        task.resume()
    }

    private func parseJSON(data: Data) -> CurrentWeather? {
        let decoder = JSONDecoder()

        do {
            let currentWeatherData = try decoder.decode(CurrentWeatherData.self, from: data)
            guard let currentWeather = CurrentWeather(currentWeatherData: currentWeatherData) else {
                return nil
            }
            return currentWeather
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
