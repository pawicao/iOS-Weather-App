//
//  ModalViewController.swift
//  pawica-prognoza-pogody
//
//  Created by Oskar on 20/06/2020.
//  Copyright © 2020 Student. All rights reserved.
//

import Foundation
import UIKit


protocol CitySelectionDelegate: class {
    func citySelected(_ newCity: String)
}

class ModalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: CitySelectionDelegate?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellString", for: indexPath)
        cell.textLabel?.text = self.cities[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = self.cities[indexPath.row]
        delegate?.citySelected(selectedCity)
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var citiesTableView: UITableView!
    
    let apiHandler = ApiHandler()
    var cities: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        citiesTableView.delegate = self
        citiesTableView.dataSource = self
    }
    
    @IBAction func cancel(_ caller: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func search(_ caller: UIButton) {
        guard let cityPrefix = self.searchField.text
            else {
            return
        }
        apiHandler.getCities(cityPrefix, completion: {(results: [String]) in
            DispatchQueue.main.async{
                self.cities = results
                self.citiesTableView.reloadData()
            }
    })
    }
}
