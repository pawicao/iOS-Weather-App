//
//  Weather.swift
//  pawica-prognoza-pogody
//
//  Created by Student on 03.06.2020.
//  Copyright © 2020 Student. All rights reserved.
//

import Foundation

struct Weather {
    

	enum SerializationError: Error {
		case missing(String)
		case invalid(String, Any)
	}

	let main: String
	let temperature: (min: Double, max: Double)
	let wind: (speed: Double, deg: Int)
	let rain: Double
	let pressure: Int
    let icon: String
    let date: String
	
	init(response: [String: Any]) throws {
        
        guard let weatherJSON = response["weather"] as? [AnyObject],
			let main = weatherJSON[0]["main"] as? String,
            let iconName = weatherJSON[0]["icon"] as? String
		else {
			throw SerializationError.missing("main")
		}
        
		guard let temperatureJSON = response["temp"] as? [String: Double],
			let min = temperatureJSON["min"],
			let max = temperatureJSON["max"]
		else {
			throw SerializationError.missing("temperature")
		}
		
		guard let pressure = response["pressure"] as? Int else {
			throw SerializationError.missing("pressure")
		}
        
        guard let dt = response["dt"] as? Double else {
            throw SerializationError.missing("dt")
        }
		
		let rain = response["rain"] as? Double ?? 0.0
		
		guard let wind_speed = response["wind_speed"] as? Double else {
			throw SerializationError.missing("wind_speed")
		}
		
		guard let wind_deg = response["wind_deg"] as? Int else {
			throw SerializationError.missing("wind_deg")
		}
        
        
		
		self.main = main
		self.temperature = (min, max)
		self.wind = (wind_speed, wind_deg)
		self.rain = rain
		self.pressure = pressure
        self.icon = iconName
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY"
        self.date = dateFormatter.string(from: Date(timeIntervalSince1970: dt))
	}
}
