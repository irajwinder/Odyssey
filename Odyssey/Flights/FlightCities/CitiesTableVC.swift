//
//  CitiesTableVC.swift
//  Odyssey
//
//  Created by Rajwinder Singh on 10/18/23.
//

import UIKit


protocol CitySelectionDelegate: AnyObject {
    func didSelectSourceCity(_ source: String)
    func didSelectDestinationCity(_ destination: String)
}

class CitiesTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var citySearchBar: UISearchBar!
    @IBOutlet weak var flightTableView: UITableView!
    
    weak var delegate: CitySelectionDelegate?
    
    //Filtered data
    var filteredData = [String]()
    
    var selectedTextfield: String?
    var selectedSourceCity: String?
    var selectedDestinationCity: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pick a City"

        // Load the list of countries from plist file
        if let path = Bundle.main.path(forResource: "Countries", ofType: "plist"),
            let plistData = FileManager.default.contents(atPath: path),
            let plistDictionary = try? PropertyListSerialization.propertyList(from: plistData, format: nil) as? [[String: Any]] {
            
            // Loop through each country
            for countryInfo in plistDictionary {
                
                // Check if the country has states
                if let states = countryInfo["states"] as? [[String: Any]] {
                    // Loop through each state
                    for state in states {
                        // Check if the state has cities
                        if let citiesInfo = state["cities"] as? [String] {
                            cities.append(contentsOf: citiesInfo)
                        }
                    }
                }
                
                // Check if the country has provinces
                if let provinces = countryInfo["provinces"] as? [[String: Any]] {
                    // Loop through each province
                    for province in provinces {
                        // Check if the province has cities
                        if let citiesInfo = province["cities"] as? [String] {
                            cities.append(contentsOf: citiesInfo)
                        }
                    }
                }
            }
        }

        flightTableView.delegate = self
        flightTableView.dataSource = self
        citySearchBar.delegate = self
    }
    
    
    // UISearchBarDelegate method to filter data based on search text
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData.removeAll()
        
        if !searchText.isEmpty {
            switch selectedTextfield {
            case "sourcecity":
                filteredData = cities.filter { $0.lowercased().contains(searchText.lowercased()) }
            case "destinationcity":
                filteredData = cities.filter { $0.lowercased().contains(searchText.lowercased()) }
            default:
                break
            }
        }
        
        // Reload the table view to reflect the filtered results
        flightTableView.reloadData()
    }

    // filtered Data when searching
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !citySearchBar.text!.isEmpty {
            return filteredData.count
        }
        
        switch selectedTextfield {
        case "sourcecity":
            return cities.count
        case "destinationcity":
            return cities.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as! CitiesTableViewCell
        var data: String?

        if !citySearchBar.text!.isEmpty {
            data = filteredData[indexPath.row]
        } else {
            switch selectedTextfield {
            case "sourcecity":
                data = cities[indexPath.row]
            case "destinationcity":
                data = cities[indexPath.row]
            default:
                break
            }
        }
        
        cell.cityName?.text = data
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            var selectedSourceCity: String?
            var selectedDestinationCity: String?

            if !citySearchBar.text!.isEmpty {
                switch selectedTextfield {
                case "sourcecity":
                    selectedSourceCity = filteredData[indexPath.row]
                case "destinationcity":
                    selectedDestinationCity = filteredData[indexPath.row]
                default:
                    break
                }
             } else {
                 switch selectedTextfield {
                 case "sourcecity":
                     selectedSourceCity = cities[indexPath.row]
                 case "destinationcity":
                     selectedDestinationCity = cities[indexPath.row]
                 default:
                     break
                 }
        }

        // Calls the delegate method to pass the selected data back to ViewController
        if let sourceCity = selectedSourceCity {
            delegate?.didSelectSourceCity(sourceCity)
        }
        if let destinationCity = selectedDestinationCity {
            delegate?.didSelectDestinationCity(destinationCity)
        }

        // Navigate back to the previous screen
        navigationController?.popViewController(animated: true)
        }
}
