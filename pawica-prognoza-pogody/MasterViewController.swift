//
//  MasterViewControllerTableViewController.swift
//  pawica-prognoza-pogody
//
//  Created by Oskar on 18/06/2020.
//  Copyright © 2020 Student. All rights reserved.
//

import UIKit

protocol CityWeatherSelectionDelegate: class {
    func cityWeatherSelected(_ newCityWeather: CityWeather)
}

class MasterViewController: UITableViewController {
    
    weak var delegate: CityWeatherSelectionDelegate?
    let apiHandler = ApiHandler()
    var cities = [CityWeather]()
    var initialCities = ["Krakow", "Warsaw", "London"]
    
    
    private func fillInitialCities() {
        for initialCity in self.initialCities {
            self.addWeather(initialCity)
        }
    }
    
    private func addWeather(_ city: String) {
        print("Elo here")
        apiHandler.getWeather(city, completion: {(results: CityWeather) in
            DispatchQueue.main.async{
                self.cities.append(results)
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: [IndexPath(row: self.cities.count - 1, section: 0)], with: .automatic)
                self.tableView.endUpdates()
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fillInitialCities()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let currentWeather = (self.cities[indexPath.row].weatherCollection.first)!
        let temperature = currentWeather.temperature.avg
        cell.textLabel?.text = self.cities[indexPath.row].cityName
        cell.detailTextLabel?.text = String(temperature) + "°C" // Add current temperature
        cell.imageView?.image = UIImage(named: "weather_icon_" + currentWeather.icon)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCityWeather = self.cities[indexPath.row]
        delegate?.cityWeatherSelected(selectedCityWeather)
        
        if let detailViewController = delegate as? ViewController {
            splitViewController?.showDetailViewController(detailViewController, sender: nil)
        }
    }
    
    // MARK: - Prepare segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddCitySegue" {
            let destination = segue.destination as! ModalViewController
            destination.delegate = self
        }
    }

}

extension MasterViewController: CitySelectionDelegate {
    func citySelected(_ newCity: String) {
        self.addWeather(newCity)
    }
}
