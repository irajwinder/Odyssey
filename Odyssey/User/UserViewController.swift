//
//  UserViewController.swift
//  Odyssey
//
//  Created by Rajwinder Singh on 10/9/23.
//

import UIKit
import CoreData

class UserViewController: UIViewController, LocationSelectionDelegate {
    
    var users: [NSManagedObject] = []
    
    func didSelectLocation(_ location: String) {
        //Handle the location selection and update the userCountry text field.
        userCountry.text = location
       }
    
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userDOB: UITextField!
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
            locationVC.delegate = self
            self.navigationController?.pushViewController(locationVC, animated: true)
        }
    }
    
    //Save the user to Core Data
    @objc func saveUser() {
        // Obtains a reference to the AppDelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        // Accessing the managed context from the persistent container
        let managedContext = appDelegate.persistentContainer.viewContext
        // Create an NSEntityDescription instance for the "User" entity
        let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)
        // Create a new NSManagedObject for the "User" entity
        let user = NSManagedObject(entity: entity!, insertInto: managedContext)

        // Set the values for various attributes of the user entity
        user.setValue(userName.text, forKeyPath: "userName")
        user.setValue(userEmail.text, forKeyPath: "userEmail")
        user.setValue(userDOB.text, forKeyPath: "userDOB")
        user.setValue(userCountry.text, forKeyPath: "userCountry")
        user.setValue(userState.text, forKeyPath: "userState")
        user.setValue(userCity.text, forKeyPath: "userCity")

        do {
            // Attempting to save the changes made to the managed context
            try managedContext.save()
            print("User data saved successfully.")
            
            //Navigate to UserList Screen
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let userListVC = storyboard.instantiateViewController(withIdentifier: "UserListViewController") as? UserListViewController {
                self.navigationController?.pushViewController(userListVC, animated: true)
            }
        } catch let error as NSError {
            // Inform the user that an error occurred while saving the data.
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

}
