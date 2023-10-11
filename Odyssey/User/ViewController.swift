//
//  ViewController.swift
//  Odyssey
//
//  Created by Rajwinder Singh on 10/9/23.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userDOB: UITextField!
    @IBOutlet weak var userCountry: UITextField!
    @IBOutlet weak var userState: UITextField!
    @IBOutlet weak var userCity: UITextField!
    
    var countries: [String] = []
    var usaStates: [String] = []
    var usaCities: [String] = []
    var canadaProvinces: [String] = []
    var canadaCities: [String] = []
    
    var countriesPickerView = UIPickerView()
    var usaStatePickerView =  UIPickerView()
    var usaCitiesPickerView =  UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pick Location"
        
        // Check the current view controller's identifier
        if let currentIdentifier = restorationIdentifier {
            if currentIdentifier == "SignUpForm" {
                // If the current view controller is "SignUpForm"
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                    barButtonSystemItem: .save, target: self, action: #selector(saveButton))
            }
        }
        
        
        userCountry.inputView = countriesPickerView
        userState.inputView = usaStatePickerView
        userCity.inputView = usaCitiesPickerView
        
        countriesPickerView.delegate = self
        countriesPickerView.dataSource = self
        usaStatePickerView.delegate = self
        usaStatePickerView.dataSource = self
        usaCitiesPickerView.delegate = self
        usaCitiesPickerView.dataSource = self
        
        countriesPickerView.tag = 1
        usaStatePickerView.tag =  2
        usaCitiesPickerView.tag =  3
        
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
    
    @objc func saveButton() {
            performSegue(withIdentifier: "goToHome", sender: nil)
        }
    
    //UIPickerViewDelegate and UIPickerViewDataSource methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // Number of components in the picker
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
            case 1:
                return countries.count
            case 2:
                return usaStates.count
            case 3:
                return usaCities.count
            default:
                return 0
            }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // Display the country names in the picker
        switch pickerView.tag {
            case 1:
                return countries[row]
            case 2:
                return usaStates[row]
            case 3:
                return usaCities[row]
            default:
                return "Data not Found"
            }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Set the selected country in the text field when a row is selected
        switch pickerView.tag {
            case 1:
                userCountry.text = countries[row]
            case 2:
                userState.text = usaStates[row]
            case 3:
                userCity.text = usaCities[row]
            default:
                return
            }
            // Hide the picker view
            pickerView.resignFirstResponder()
    }
}
