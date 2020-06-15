//
//  ViewController.swift
//  pawica-prognoza-pogody
//
//  Created by Student on 27.05.2020.
//  Copyright © 2020 Student. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var data = [Weather]()

    override func viewDidLoad() {
        super.viewDidLoad()
		
	    //Hardcoded location for testing (Krakow)
	    let lat = 50.062149
	    let lon = 19.944588
		
		let weather = ApiHandler()
		weather.getWeather(lat, lon, completion: {(results: [Weather]?) in
          if let weatherData = results {
            self.data = weatherData
			for weather in weatherData {
			  print("Hello ", weather.main)
			}
            //DispatchQueue.main.async {
            //  self.
          }
		})
    }


}

