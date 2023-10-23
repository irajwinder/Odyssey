//
//  EditUserVC.swift
//  Odyssey
//
//  Created by Rajwinder Singh on 10/21/23.
//

import UIKit

class EditUserVC: UIViewController, LocationSelectionDelegate {
    
    func didSelectCountry(_ country: String) {
        //Updates the text fields
        editUserCountry.text = country
    }
    func didSelectState(_ state: String) {
        editUserState.text = state
    }
    func didSelectCity(_ city: String) {
        editUserCity.text = city
    }
    
    @IBOutlet weak var editUserName: UITextField!
    @IBOutlet weak var editUserEmail: UITextField!
    @IBOutlet weak var editUserDOB: UIDatePicker!
    @IBOutlet weak var editUserCountry: UITextField!
    @IBOutlet weak var editUserState: UITextField!
    @IBOutlet weak var editUserCity: UITextField!
    
    var user: User?
    var isEditingEnabled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Update User Details"
        
        // Check the current view controller's identifier
        if let currentIdentifier = restorationIdentifier {
            if currentIdentifier == "EditUserVC" {
                if isEditingEnabled {
                    // If editing is enabled, show "Save" button
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                        title: "Save", style: .plain, target: self, action: #selector(saveButton))
                } else {
                    // If editing is not enabled, show "Edit" button
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                        title: "Edit", style: .plain, target: self, action: #selector(editButton))
                }
            }
        }
        
        //Disable editing
        editUserName.isEnabled = isEditingEnabled
        editUserEmail.isEnabled = isEditingEnabled
        editUserDOB.isEnabled = isEditingEnabled
        editUserCountry.isEnabled = isEditingEnabled
        editUserState.isEnabled = isEditingEnabled
        editUserCity.isEnabled = isEditingEnabled
        
        //Set the user info
        if let user = user {
            editUserName.text = user.userName
            editUserEmail.text = user.userEmail
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            if let date = dateFormatter.date(from: user.userDOB ?? "nil") {
                editUserDOB.date = date
            } else {
                //date conversion fails
                print("Failed to convert userDOB to Date.")
            }
            editUserCountry.text = user.userCountry
            editUserState.text = user.userState
            editUserCity.text = user.userCity
        }
    }
    
    @IBAction func editUserCountry(_ sender: Any) {
        if isEditingEnabled {
            openLocationViewController("country")
        }
    }
    
    @IBAction func editUserState(_ sender: Any) {
        // Check if a country has been selected
        if isEditingEnabled {
            if editUserCountry.text?.isEmpty == false {
                openLocationViewController("state")
            } else {
                Validation.showAlert(on: self, with: "Country Not Selected", message: "Please select a country before selecting a state.")
            }
        }
    }
    
    @IBAction func editUserCity(_ sender: Any) {
        if isEditingEnabled {
            if editUserCountry.text?.isEmpty == true {
                // If country is not selected, shows an alert to select the country and state
                Validation.showAlert(on: self, with: "Country/State Not Selected", message: "Please select a country and a state before selecting a city.")
            } else if editUserState.text?.isEmpty == true {
                // If country is selected but state is not selected, shows an alert to select state
                Validation.showAlert(on: self, with: "State Not Selected", message: "Please select a state before selecting a city.")
            } else {
                // If both country and state are selected, allowa the user to select the city
                openLocationViewController("city")
            }
        }
    }
    
    func openLocationViewController(_ selectedTextfield: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let locationVC = storyboard.instantiateViewController(withIdentifier: "CountryListVC") as? CountryListVC {
            locationVC.selectedTextfield = selectedTextfield
            locationVC.selectedCountry = editUserCountry.text
            locationVC.selectedState = editUserState.text
            locationVC.delegate = self
            self.navigationController?.pushViewController(locationVC, animated: true)
        }
    }

    
    @objc func editButton() {
        //Enable editing and change button to "Save"
        isEditingEnabled = true
        viewDidLoad() // Refresh the view to apply changes
    }
    
    @objc func saveButton() {
        //Validate before saving
        guard let name = editUserName.text, Validation.isValidName(name) else {
            Validation.showAlert(on: self, with: "Invalid Name", message: "Please enter a valid name.")
               return
           }
           
        guard let email = editUserEmail.text, Validation.isValidEmail(email) else {
            Validation.showAlert(on: self, with: "Invalid Email", message: "Please enter a valid email address.")
            return
        }
        
        let dob = editUserDOB.date
        guard Validation.isValidDateOfBirth(dob) else {
            Validation.showAlert(on: self, with: "Invalid Date of Birth", message: "Please select a valid date of birth.")
            return
        }
        
        guard let country = editUserCountry.text, Validation.isValidCountry(country) else {
            Validation.showAlert(on: self, with: "Invalid Country", message: "Please enter a valid country.")
            return
        }
        
        guard let state = editUserState.text, Validation.isValidState(state) else {
            Validation.showAlert(on: self, with: "Invalid State", message: "Please enter a valid state.")
            return
        }
        
        guard let city = editUserCity.text, Validation.isValidCity(city) else {
            Validation.showAlert(on: self, with: "Invalid City", message: "Please enter a valid city.")
            return
        }
        
        // Save changes and disable editing
        isEditingEnabled = false
                
        guard let user = user else {
            // Handle the case when the user object is nil
            print("Error: User object is nil.")
            return
        }
        
        datamanagerInstance.updateUser(
            user: user,
            editUserName: editUserName.text ?? "",
            editUserEmail: editUserEmail.text ?? "",
            editUserDOB: editUserDOB.date,
            editUserCountry: editUserCountry.text ?? "",
            editUserState: editUserState.text ?? "",
            editUserCity: editUserCity.text ?? ""
        )
        navigationController?.popViewController(animated: true)
    }
}
