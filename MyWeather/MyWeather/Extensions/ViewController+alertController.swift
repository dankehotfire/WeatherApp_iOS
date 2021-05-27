//
//  ViewController+alertController.swift
//  MyWeather
//
//  Created by Danil Nurgaliev on 20.05.2021.
//

import UIKit

extension ViewController {
    func presentSearchAlertController(title: String?, message: String?, completionHandler: @escaping (String) -> Void) {
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
