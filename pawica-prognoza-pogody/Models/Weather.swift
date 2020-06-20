//
//  Weather.swift
//  pawica-prognoza-pogody
//
//  Created by Student on 03.06.2020.
//  Copyright © 2020 Student. All rights reserved.
//

import Foundation

struct CityWeather {
    let cityName: String
    let weatherCollection: [Weather]
    
    init(name: String, arr: [Weather]) {
        self.cityName = name
        self.weatherCollection = arr
    }
}

struct Weather {
    

	enum SerializationError: Error {
		case missing(String)
		case invalid(String, Any)
	}

	let main: String
    let temperature: (min: Double, max: Double, avg: Double)
	let wind: (speed: Double, deg: Int)
	let rain: Double
	let pressure: Int
    let icon: String
    let date: String
	
	init(response: [String: Any]) throws {
        guard let weatherJSON = response["weather"] as? [AnyObject],
			let main = weatherJSON[0]["description"] as? String,
            let iconName = weatherJSON[0]["icon"] as? String
		else {
			throw SerializationError.missing("main_description")
		}
        
        guard let mainJSON = response["main"] as? [String: Any],
            let min = mainJSON["temp_min"] as? Double,
            let max = mainJSON["temp_max"] as? Double,
            let avg = mainJSON["temp"] as? Double,
            let pressure = mainJSON["pressure"] as? Int
        else {
            throw SerializationError.missing("main")
        }
        
        guard let windJSON = response["wind"] as? [String: Any],
            let wind_speed = windJSON["speed"] as? Double,
            let wind_deg = windJSON["deg"] as? Int
        else {
            throw SerializationError.missing("wind")
        }
		
        guard let dt = response["dt"] as? Double else {
            throw SerializationError.missing("dt")
        }
		
        var rain = 0.0
        let rainWrapper = response["rain"] as? [String: Double]
        rain = rainWrapper?["3h"] ?? 0.0
        
		
		self.main = main
		self.temperature = (min, max, avg)
		self.wind = (wind_speed, wind_deg)
		self.rain = rain
		self.pressure = pressure
        self.icon = iconName
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY"
        self.date = dateFormatter.string(from: Date(timeIntervalSince1970: dt))
	}
}
