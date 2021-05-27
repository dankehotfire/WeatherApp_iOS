//
//  CurrentWeather.swift
//  MyWeather
//
//  Created by Danil Nurgaliev on 20.05.2021.
//

import Foundation

class CurrentWeather {
    let cityName: String

    let temperature: Double
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }

    let feelsLikeTemperature: Double
    var feelsLikeTempString: String {
        return String(format: "%.1f", feelsLikeTemperature)
    }

    let windSpeed: Double
    let humidity: Int
    let weatherDescription: String

    let conditionId: Int
    var systemIconNameString: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt.rain.fill"
        case 300...321:
            return "cloud.drizzle.fill"
        case 500...531:
            return "cloud.rain.fill"
        case 600...622:
            return "cloud.snow.fill"
        case 701...781:
            return "smoke.fill"
        case 800:
            return "sun.min.fill"
        case 801...804:
            return "cloud.fill"
        default:
            return "nosign"
        }
    }

    init?(currentWeatherData: CurrentWeatherData) {
        guard let weather = currentWeatherData.weather.first else {
            return nil
        }

        cityName = currentWeatherData.name
        temperature = currentWeatherData.main.temp
        feelsLikeTemperature = currentWeatherData.main.feelsLike
        conditionId = weather.weatherId
        windSpeed = currentWeatherData.wind.speed
        humidity = currentWeatherData.main.humidity
        weatherDescription = weather.weatherDescription
    }
}
