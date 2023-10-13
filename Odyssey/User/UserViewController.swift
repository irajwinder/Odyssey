//
//  UserViewController.swift
//  Odyssey
//
//  Created by Rajwinder Singh on 10/9/23.
//

import UIKit

class UserViewController: UIViewController, LocationSelectionDelegate {
    
    func didSelectLocation(_ location: String) {
        // Handle the location selection and update the userCountry text field.
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
                    barButtonSystemItem: .save, target: self, action: nil)
            }
        }

        
    }
}
