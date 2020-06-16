//
//  ViewController.swift
//  pawica-prognoza-pogody
//
//  Created by Student on 27.05.2020.
//  Copyright © 2020 Student. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var currentDay = 0
    private var lastDay = 5

    private var data = [Weather]()
    
    @IBOutlet weak var tempMax: UITextField!
    @IBOutlet weak var tempMin: UITextField!
    @IBOutlet weak var pressure: UITextField!
    @IBOutlet weak var windSpeed: UITextField!
    @IBOutlet weak var windDegree: UITextField!
    @IBOutlet weak var weatherDescription: UITextField!
    @IBOutlet weak var rain: UITextField!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var previousDayButton: UIButton!
    @IBOutlet weak var nextDayButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
		
	    //Hardcoded location for testing (Krakow)
	    let lat = 50.062149
	    let lon = 19.944588
		let weather = ApiHandler()
		weather.getWeather(lat, lon, completion: {(results: [Weather]) in
            self.data = results
            self.Update()
		})
    }

    func Update() {
        DispatchQueue.main.async{
            self.tempMax.text = String(self.data[self.currentDay].temperature.max) + "°C"
            self.tempMin.text = String(self.data[self.currentDay].temperature.min) + "°C"
            self.weatherDescription.text = self.data[self.currentDay].main
            self.pressure.text = String(self.data[self.currentDay].pressure) + "hPa"
            self.rain.text = String(self.data[self.currentDay].rain) + "mm"
            self.windSpeed.text = String(self.data[self.currentDay].wind.speed) + "m/s"
            self.windDegree.text = String(self.data[self.currentDay].wind.deg) + "°"
            self.getElementFromUrl(url: URL(string: "https://openweathermap.org/img/wn/" + self.data[self.currentDay].icon + "@2x.png")!)
            self.date.text = self.data[self.currentDay].date
            
            if self.currentDay == 0 {
                self.previousDayButton.isEnabled = false
            }
            else {
                self.previousDayButton.isEnabled = true
            }
            
            if self.currentDay == self.lastDay {
                self.nextDayButton.isEnabled = false
            }
            else {
                self.nextDayButton.isEnabled = true
            }
        }
    }
    
    func getElementFromUrl(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let elem = try? Data(contentsOf: url) {
                if let img = UIImage(data: elem) {
                    DispatchQueue.main.async {
                        self?.icon.image = img
                    }
                }
            }
        }
    }
    
    @IBAction func goBack(_ caller: UIButton) {
        self.currentDay -= 1
        self.Update()
    }
    
    @IBAction func goNext(_ caller: UIButton) {
        self.currentDay += 1
        self.Update()
    }
}

