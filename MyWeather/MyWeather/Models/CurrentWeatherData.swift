//
//  CurrentWeatherData.swift
//  MyWeather
//
//  Created by Danil Nurgaliev on 20.05.2021.
//

import Foundation

struct Main: Codable {
    enum CodingKeys: String, CodingKey {
        case temp = "temp"
        case feelsLike = "feels_like"
        case humidity = "humidity"
    }

    let temp: Double
    let feelsLike: Double
    let humidity: Int
}

struct Weather: Codable {
    enum CodingKeys: String, CodingKey {
        case weatherId = "id"
        case weatherDescription = "description"
    }

    let weatherId: Int
    let weatherDescription: String
}

struct Wind: Codable {
    let speed: Double
}

struct CurrentWeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    let wind: Wind
}
