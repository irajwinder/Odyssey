//
//  ViewController.swift
//  Odyssey
//
//  Created by Rajwinder Singh on 10/9/23.
//

import UIKit

class ViewController: UIViewController, LocationSelectionDelegate {
    
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
        title = "User Form"
        
        // Check the current view controller's identifier
        if let currentIdentifier = restorationIdentifier {
            if currentIdentifier == "UserForm" {
                // If the current view controller is "SignUpForm"
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                    barButtonSystemItem: .save, target: self, action: nil)
            }
        }
        
        //tap gesture recognizer for userCountry text field
        let countryRecognizer = UITapGestureRecognizer(target: self, action: #selector(userCountryTapped))
        userCountry.addGestureRecognizer(countryRecognizer)
        userCountry.isUserInteractionEnabled = true
        
        // tap gesture recognizer for userState text field
        let stateRecognizer = UITapGestureRecognizer(target: self, action: #selector(userStateTapped))
        userState.addGestureRecognizer(stateRecognizer)
        userState.isUserInteractionEnabled = true
        
        // tap gesture recognizer for userCity text field
        let cityRecognizer = UITapGestureRecognizer(target: self, action: #selector(userCityTapped))
        userCity.addGestureRecognizer(cityRecognizer)
        userCity.isUserInteractionEnabled = true
        
    }
    
    @objc func userCountryTapped() {
        if let locationVC = storyboard?.instantiateViewController(withIdentifier: "LocationViewController") as? LocationViewController {
            locationVC.delegate = self
            navigationController?.pushViewController(locationVC, animated: true)
        }
    }

    @objc func userStateTapped() {
        if let locationVC = storyboard?.instantiateViewController(withIdentifier: "LocationViewController") as? LocationViewController {
            locationVC.delegate = self
            navigationController?.pushViewController(locationVC, animated: true)
        }
    }
    
    @objc func userCityTapped() {
        if let locationVC = storyboard?.instantiateViewController(withIdentifier: "LocationViewController") as? LocationViewController {
            locationVC.delegate = self
            navigationController?.pushViewController(locationVC, animated: true)
        }
    }
    
}
