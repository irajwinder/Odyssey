//
//  UserViewController.swift
//  Odyssey
//
//  Created by Rajwinder Singh on 10/9/23.
//

import UIKit
import CoreData

class UserViewController: UIViewController, LocationSelectionDelegate {
    
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
            if currentIdentifier == "UserViewController" {
                // If the current view controller is "SignUpForm"
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                    barButtonSystemItem: .save, target: self, action: #selector(saveUser))
            }
        }
    }
    
    
    @IBAction func userCountry(_ sender: Any) {
        openLocationViewController("country")
    }
    
    @IBAction func userState(_ sender: Any) {
        openLocationViewController("state")
    }
    @IBAction func userCity(_ sender: Any) {
        openLocationViewController("city")
    }
    
    func openLocationViewController(_ selectedTextfield: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let locationVC = storyboard.instantiateViewController(withIdentifier: "LocationViewController") as? LocationViewController {
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
        
        // Obtains a reference to the AppDelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        // Accessing the managed context from the persistent container
        let managedContext = appDelegate.persistentContainer.viewContext

        //Create a newUser Object
        let newUser = User(context: managedContext)
        
        // Set the values for various attributes of the user entity
        newUser.userName = self.userName.text
        newUser.userEmail = self.userEmail.text
        let dateFormatter = DateFormatter() // Convert Date to String using DateFormatter
        dateFormatter.dateFormat = "MM/dd/yyyy" // Setdate format
        let dateString = dateFormatter.string(from: self.userDOB.date)
        newUser.userDOB = dateString
        newUser.userCountry = self.userCountry.text
        newUser.userState = self.userState.text
        newUser.userCity = self.userCity.text

        do {
            // Attempting to save the changes made to the managed context
            try managedContext.save()
            print("User data saved successfully.")
            
            // Instantiate the UserListViewController from the storyboard
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let userListVC = storyboard.instantiateViewController(withIdentifier: "UserListViewController") as? UserListViewController {
                // Push the UserListViewController onto the navigation stack
                self.navigationController?.pushViewController(userListVC, animated: true)
            }
        } catch let error as NSError {
            // Inform the user that an error occurred while saving the data.
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

}
