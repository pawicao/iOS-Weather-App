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
        
        for city in cities {
            print(city.cityName)
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    //override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
    //    return 0
    //}

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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
