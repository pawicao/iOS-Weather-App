//
//  ApiHandler.swift
//  pawica-prognoza-pogody
//
//  Created by Student on 27.05.2020.
//  Copyright © 2020 Student. All rights reserved.
//

import Foundation

class ApiHandler {
  
  private let baseURL = "https://api.openweathermap.org/data/2.5/forecast"
  private let APIKey = "8eec1ab6030b33a264452699708b1f87"
    
  func getWeather(_ city: String, completion: @escaping (CityWeather) -> Void) {
    let correctedCity = city.replacingOccurrences(of: " ", with: "+")
    let requestURL = URL(string: "\(baseURL)?APPID=\(APIKey)&units=metric&q=\(correctedCity)")!
    var weatherCollection: [Weather] = []
    
    let session = URLSession.shared.dataTask(with: requestURL, completionHandler:
      {data, response, error in
        if (error == nil && data != nil) {
            if let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
              if let responseArray = json?["list"] as? [[String: Any]] {
                for index in stride(from: 0, to: 5*8, by: 8) { // API is for 5 days, each day has 8 records
                    let weather = try? Weather(response: responseArray[index])
                    if let unwrapped = weather {
                        weatherCollection.append(unwrapped)
                    }
                }
              }
            }
        }
        completion(CityWeather(name: city, arr: weatherCollection))
      }
	)
    session.resume()
  }
    
    func getCities(_ citySubstring: String, completion: @escaping ([String]) -> Void) {
        let correctedPrefix = citySubstring.replacingOccurrences(of: " ", with: "+")
        let requestURL = URL(string: "http://geodb-free-service.wirefreethought.com/v1/geo/cities?limit=10&namePrefix=\(correctedPrefix)")!
        var citiesCollection: [String] = []
        
        let session = URLSession.shared.dataTask(with: requestURL, completionHandler:
          {data, response, error in
            if (error == nil && data != nil) {
                if let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                  if let responseArray = json?["data"] as? [[String: Any]] {
                    for city in responseArray {
                        let cityName = city["name"] as! String
                        citiesCollection.append(cityName)
                    }
                  }
                }
            }
            completion(citiesCollection)
          }
        )
        session.resume()
        
    }
}
