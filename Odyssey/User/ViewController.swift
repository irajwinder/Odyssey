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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pick Location"
        
        countryPicker.delegate = self
        countryPicker.dataSource = self
        
        // Load the list of countries from your plist file
        if let path = Bundle.main.path(forResource: "Countries", ofType: "plist"),
           let plistData = FileManager.default.contents(atPath: path),
           let plistDictionary = try? PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [[String: Any]] {
            
            for countryInfo in plistDictionary {
                if let countryName = countryInfo["name"] as? String {
                    countries.append(countryName)
                }
            }
        }
        
    }
    
    
    @IBAction func submitButton(_ sender: Any) {
        // Create a dictionary with user input
        if let path = Bundle.main.path(forResource: "Countries", ofType: "plist"),
           let plistData = FileManager.default.contents(atPath: path),
           let plistDictionary = try? PropertyListSerialization.propertyList(from: plistData, format: nil) as? [[String: Any]] {
            
            // Extract country names from the plist data
            var countryNames = [String]()
            for countryInfo in plistDictionary {
                if let name = countryInfo["name"] as? String {
                    countryNames.append(name)
                }
            }
            
        }
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
