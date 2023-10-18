//
//  FlightsViewController.swift
//  Odyssey
//
//  Created by Rajwinder Singh on 10/12/23.
//

import UIKit

class FlightsViewController: UIViewController, LocationSelectionDelegate {
    
    func didSelectLocation(_ location: String) {
        // Handle the location selection and update the userCountry text field.
        //userCountry.text = location
       }
    
    @IBOutlet weak var flightNumber: UITextField!
    @IBOutlet weak var sourceCity: UITextField!
    @IBOutlet weak var destinationCity: UITextField!
    @IBOutlet weak var departureDate: UIDatePicker!
    @IBOutlet weak var returnDate: UIDatePicker!
    @IBOutlet weak var returnDateLabel: UILabel!
    @IBOutlet weak var segmantControl: UISegmentedControl!
    
    
    private enum PageType {
        case oneway
        case roundtrip
    }
    
    private var currentPageType: PageType = .oneway {
        didSet {
            setupViewsFor(pagetype: currentPageType)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Flights"
        
        // Check the current view controller's identifier
        if let currentIdentifier = restorationIdentifier {
            if currentIdentifier == "FlightsViewController" {
                // If the current view controller is "SignUpForm"
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                    barButtonSystemItem: .save, target: self, action: #selector(saveButton))
            }
        }
        
        setupViewsFor(pagetype: .oneway)
    }
    
    @objc func saveButton() {
        //Validate before saving
        guard let flightNumberText = flightNumber.text, let flightNumber = Int(flightNumberText), Validation.isValidNumber(flightNumber) else {
            Validation.showAlert(on: self, with: "Invalid Flight Number", message: "Please enter a valid Flight Number.")
            return
        }
        
        guard let sourceCity = sourceCity.text, Validation.isValidCity(sourceCity) else {
            Validation.showAlert(on: self, with: "Invalid City", message: "Please enter a valid Source City.")
            return
        }
        
        guard let destinationCity = destinationCity.text, Validation.isValidState(destinationCity) else {
            Validation.showAlert(on: self, with: "Invalid City", message: "Please enter a valid Destination City.")
            return
        }
        
        let departureDate = departureDate.date
        guard Validation.isValidDepartureDate(departureDate) else {
            Validation.showAlert(on: self, with: "Invalid Date", message: "Please select a valid Departure Date.")
            return
        }
        
        if currentPageType == .roundtrip {
            let returnDate = returnDate.date
            guard Validation.isValidReturnDate(returnDate, departureDate: departureDate) else {
                Validation.showAlert(on: self, with: "Invalid Date", message: "Return date must be after departure date")
                return
            }
        }
        
        performSegue(withIdentifier: "selectSeat", sender: nil)
    }
    
    //Hides the return date if segmant name is oneway
    private func setupViewsFor(pagetype: PageType) {
        returnDate.isHidden = pagetype == .oneway
        returnDateLabel.isHidden = pagetype == .oneway
    }
    
    
    @IBAction func selectSourceCity(_ sender: Any) {
        openLocationViewController("city")
    }
    
    @IBAction func selectDestinationCity(_ sender: Any) {
        openLocationViewController("city")
    }
    
    //Handles segment change
    @IBAction func segmantControlChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            currentPageType = .oneway
        } else {
            currentPageType = .roundtrip
        }
    }
    
    
    func openLocationViewController(_ selectedTextfield: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let locationVC = storyboard.instantiateViewController(withIdentifier: "LocationViewController") as? LocationViewController {
            locationVC.selectedTextfield = selectedTextfield
            locationVC.delegate = self
            self.navigationController?.pushViewController(locationVC, animated: true)
        }
    }

}
