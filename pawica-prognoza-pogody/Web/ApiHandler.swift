//
//  ApiHandler.swift
//  pawica-prognoza-pogody
//
//  Created by Student on 27.05.2020.
//  Copyright © 2020 Student. All rights reserved.
//

import Foundation

class ApiHandler {
  
  private let baseURL = "https://api.openweathermap.org/data/2.5/onecall"
  private let APIKey = "8eec1ab6030b33a264452699708b1f87"
  
  func getWeather(_ lat: Double,_ lon: Double, completion: @escaping ([Weather]?) -> ()) {
    let requestURL = URL(string: "\(baseURL)?APPID=\(APIKey)&units=metric&exclude=minutely,current,hourly&lat=\(lat)&lon=\(lon)")!
    var weatherCollection: [Weather] = []
        
    let session = URLSession.shared.dataTask(with: requestURL, completionHandler:
      {data, response, error in
        if (error == nil && data != nil) {
          DispatchQueue.main.async {
            if let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
              if let responseArray = json?["daily"] as? [[String: Any]] {
                for dailyWeather in responseArray {
                  let weather = try? Weather(response: dailyWeather)
                  if let unwrapped = weather {
                    weatherCollection.append(unwrapped)
                  }
                }
              }
            }
          }
        }
        completion(weatherCollection)
      }
	)
    session.resume()
  }
}
