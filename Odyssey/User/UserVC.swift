//
//  UserVC.swift
//  Odyssey
//
//  Created by Rajwinder Singh on 10/9/23.
//

import UIKit
import CoreData

class UserVC: UIViewController, LocationSelectionDelegate {
    
    func didSelectCountry(_ country: String) {
        //Updates the text fields
        userCountry.text = country
    }
    func didSelectState(_ state: String) {
        userState.text = state
    }
    func didSelectCity(_ city: String) {
        userCity.text = city
    }
    
    var users: [User] = []
    
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userDOB: UIDatePicker!
    @IBOutlet weak var userCountry: UITextField!
    @IBOutlet weak var userState: UITextField!
    @IBOutlet weak var userCity: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "User Form"
        
        // Check the current view controller's identifier
        if let currentIdentifier = restorationIdentifier {
            if currentIdentifier == "UserVC" {
                // If the current view controller is "UserVC"
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                    barButtonSystemItem: .save, target: self, action: #selector(saveUser))
            }
        }
        
        //Disable editing of text fields
        userCountry.isEnabled = false
        userState.isEnabled = false
        userCity.isEnabled = false
    }
    
    @IBAction func userCountry(_ sender: Any) {
        openLocationViewController("country")
    }
    
    @IBAction func userState(_ sender: Any) {
        // Check if a country has been selected
        if userCountry.text?.isEmpty == false {
            openLocationViewController("state")
        } else {
            Validation.showAlert(on: self, with: "Country Not Selected", message: "Please select a country before selecting a state.")
        }
    }
    
    @IBAction func userCity(_ sender: Any) {
        if userCountry.text?.isEmpty == true {
                // If country is not selected, shows an alert to select the country and state
                Validation.showAlert(on: self, with: "Country/State Not Selected", message: "Please select a country and a state before selecting a city.")
            } else if userState.text?.isEmpty == true {
                // If country is selected but state is not selected, shows an alert to select state
                Validation.showAlert(on: self, with: "State Not Selected", message: "Please select a state before selecting a city.")
            } else {
                // If both country and state are selected, allowa the user to select the city
                openLocationViewController("city")
            }
    }
    
    func openLocationViewController(_ selectedTextfield: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let locationVC = storyboard.instantiateViewController(withIdentifier: "CountryListVC") as? CountryListVC {
            locationVC.selectedTextfield = selectedTextfield
            locationVC.selectedCountry = userCountry.text
            locationVC.selectedState = userState.text
            locationVC.delegate = self
            self.navigationController?.pushViewController(locationVC, animated: true)
        }
    }
    
    //Save the user to Core Data
    @objc func saveUser() {
        //Validate before saving
        guard let name = userName.text, Validation.isValidName(name) else {
            Validation.showAlert(on: self, with: "Invalid Name", message: "Please enter a valid name.")
               return
           }
           
        guard let email = userEmail.text, Validation.isValidEmail(email) else {
            Validation.showAlert(on: self, with: "Invalid Email", message: "Please enter a valid email address.")
            return
        }
        
        let dob = userDOB.date
        guard Validation.isValidDateOfBirth(dob) else {
            Validation.showAlert(on: self, with: "Invalid Date of Birth", message: "Please select a valid date of birth.")
            return
        }
        
        guard let country = userCountry.text, Validation.isValidCountry(country) else {
            Validation.showAlert(on: self, with: "Invalid Country", message: "Please enter a valid country.")
            return
        }
        
        guard let state = userState.text, Validation.isValidState(state) else {
            Validation.showAlert(on: self, with: "Invalid State", message: "Please enter a valid state.")
            return
        }
        
        guard let city = userCity.text, Validation.isValidCity(city) else {
            Validation.showAlert(on: self, with: "Invalid City", message: "Please enter a valid city.")
            return
        }
        
        //save user data using datamanagerInstance
        datamanagerInstance.saveUser(
            userName: self.userName.text ?? "",
            userEmail: self.userEmail.text ?? "",
            userDOB: self.userDOB.date,
            userCountry: self.userCountry.text ?? "",
            userState: self.userState.text ?? "",
            userCity: self.userCity.text ?? ""
        )

        // Instantiate the UserListVC from the storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let userListVC = storyboard.instantiateViewController(withIdentifier: "UserListVC") as? UserListVC {
            // Push the UserListVC onto the navigation stack
            self.navigationController?.pushViewController(userListVC, animated: true)
        }
    }

}
