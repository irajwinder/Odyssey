//
//  ViewController.swift
//  Odyssey
//
//  Created by Rajwinder Singh on 10/9/23.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var cityTextField: UILabel!
    
    @IBOutlet weak var countryPicker: UIPickerView!
    
    var countries: [String] = []
    var usaStates: [String] = []
    var usaCities: [String] = []
    var canadaProvinces: [String] = []
    var canadaCities: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pick Location"
        
        countryPicker.delegate = self
        countryPicker.dataSource = self
        
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
    }
    
    
    @IBAction func submitButton(_ sender: Any) {
        //On submit
    }
    
    //UIPickerViewDelegate and UIPickerViewDataSource methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // Number of components in the picker (just one, the list of countries)
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countries[row] // Display the country names in the picker
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Set the selected country in the text field when a row is selected
        countryTextField.text = countries[row]
    }
}
