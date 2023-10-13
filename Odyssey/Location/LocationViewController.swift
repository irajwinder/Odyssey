//
//  LocationViewController.swift
//  Odyssey
//
//  Created by Rajwinder Singh on 10/11/23.
//

import UIKit

protocol LocationSelectionDelegate: AnyObject {
    func didSelectLocation(_ location: String)
}


class LocationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var countryTableView: UITableView!
    
    weak var delegate: LocationSelectionDelegate?

    //Filtered data
    var filteredData = [String]()
    
    var selectedTextfield: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pick a location"
        
        // Load the list of countries from plist file
        if let path = Bundle.main.path(forResource: "Countries", ofType: "plist"),
           let plistData = FileManager.default.contents(atPath: path),
           let plistDictionary = try? PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [[String: Any]] {
            
            //Stores countries info
            for Countires in plistDictionary {
                if let countryName = Countires["name"] as? String {
                    countries.append(countryName)
                }
                
                if let UnitedStates = Countires["states"] as? [[String: Any]] {
                    for state in UnitedStates {
                        //stores states name into usaStates array
                        if let stateName = state["name"] as? String {
                            usaStates.append(stateName)
                        }
                        //stores cities name into usaCities array
                        if let citiesInfo = state["cities"] as? [String] {
                            usaCities.append(contentsOf: citiesInfo)
                        }
                    }
                }
                
                if let Canada = Countires["provinces"] as? [[String: Any]] {
                    for province in Canada {
                        //stores provinces name into canadaProvinces array
                        if let provinceName = province["name"] as? String {
                            canadaProvinces.append(provinceName)
                        }
                        //stores cities name into canadaCities array
                        if let citiesInfo = province["cities"] as? [String] {
                            canadaCities.append(contentsOf: citiesInfo)
                        }
                        
                    }
                }
            }
        }
        
        countryTableView.delegate = self
        countryTableView.dataSource = self
        searchBar.delegate = self
        
        print(selectedTextfield!)
    }
    
    // UISearchBarDelegate method to filter data based on search text
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData.removeAll()
        
        if !searchText.isEmpty {
            // Filter the original data based on the search text
            filteredData = countries.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
        
        // Reload the table view to reflect the filtered results
        countryTableView.reloadData()
    }

    // filtered Data when searching
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !searchBar.text!.isEmpty {
            return filteredData.count
        }

        switch selectedTextfield {
        case "country":
            return countries.count
        case "state":
            return usaStates.count
        case "city":
            return usaCities.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath) as! TableViewCell
        var data: String?

        if !searchBar.text!.isEmpty {
            data = filteredData[indexPath.row]
        } else {
            switch selectedTextfield {
            case "country":
                data = countries[indexPath.row]
            case "state":
                data = usaStates[indexPath.row]
            case "city":
                data = usaCities[indexPath.row] // Modify this to return city data as needed.
            default:
                break
            }
        }

        cell.countriesName?.text = data
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            var selectedData: String?

            if !searchBar.text!.isEmpty {
            selectedData = filteredData[indexPath.row]
            } else {
                switch selectedTextfield {
                case "country":
                    selectedData = countries[indexPath.row]
                case "state":
                    selectedData = usaStates[indexPath.row]
                case "city":
                    selectedData = usaCities[indexPath.row]
//                case 3:
//                    selectedData = canadaProvinces[indexPath.row]
//                case 4:
//                    selectedData = canadaCities[indexPath.row]
                default:
                    break
                }
        }
        
        print(selectedData)

        // Calls the delegate method to pass the selected data back to ViewController
        delegate?.didSelectLocation(selectedData ?? "nil")
        // Navigate back to the previous screen
        navigationController?.popViewController(animated: true)
        }
}
