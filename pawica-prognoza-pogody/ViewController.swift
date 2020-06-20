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
    private var lastDay = 4

    private var data: CityWeather? {
        didSet {
            self.currentDay = 0
            Update()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func Update() {
        loadViewIfNeeded()
        self.tempMax.text = String(self.data!.weatherCollection[self.currentDay].temperature.max) + "°C"
        self.tempMin.text = String(self.data!.weatherCollection[self.currentDay].temperature.min) + "°C"
        self.weatherDescription.text = self.data!.weatherCollection[self.currentDay].main
        self.pressure.text = String(self.data!.weatherCollection[self.currentDay].pressure) + "hPa"
        self.rain.text = String(self.data!.weatherCollection[self.currentDay].rain) + "mm"
        self.windSpeed.text = String(self.data!.weatherCollection[self.currentDay].wind.speed) + "m/s"
        self.windDegree.text = String(self.data!.weatherCollection[self.currentDay].wind.deg) + "°"
        self.icon.image = UIImage(named: "weather_icon_" + self.data!.weatherCollection[self.currentDay].icon)
        self.date.text = self.data!.weatherCollection[self.currentDay].date
        self.cityName.text = self.data!.cityName
        
        self.title = self.data!.cityName
        
        self.previousDayButton.isEnabled = !(self.currentDay == 0)
        self.nextDayButton.isEnabled = !(self.currentDay == self.lastDay)
    }
    
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
    @IBOutlet weak var cityName: UILabel!
    
    @IBAction func goBack(_ caller: UIButton) {
        self.currentDay -= 1
        self.Update()
    }
    
    @IBAction func goNext(_ caller: UIButton) {
        self.currentDay += 1
        self.Update()
    }
}

extension ViewController: CityWeatherSelectionDelegate {
    func cityWeatherSelected(_ newCityWeather: CityWeather) {
        data = newCityWeather
    }
}
