//
//  FlightsViewController.swift
//  Odyssey
//
//  Created by Rajwinder Singh on 10/12/23.
//

import UIKit

class FlightsViewController: UIViewController, CitySelectionDelegate {
    func didSelectSourceCity(_ source: String) {
        //Updates the text fields
        sourceCity.text = source
    }
    
    func didSelectDestinationCity(_ destination: String) {
        destinationCity.text = destination
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
        
        //By default segmant oneway
        setupViewsFor(pagetype: .oneway)
        
        //Disable editing of text fields
        sourceCity.isEnabled = false
        destinationCity.isEnabled = false
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
            Validation.showAlert(on: self, with: "Invalid Date", message: "Please select a valid Departure Date > \(departureDate)")
            return
        }
        
        if currentPageType == .roundtrip {
            let returnDate = returnDate.date
            guard Validation.isValidReturnDate(returnDate, departureDate: departureDate) else {
                Validation.showAlert(on: self, with: "Invalid Date", message: "Return date must be after departure date")
                return
            }
        }
        
        let data: [String: Any] = [
            "flightNumber": flightNumberText,
            "sourceCity": sourceCity,
            "destinationCity": destinationCity,
            "departureDate": departureDate,
            "returnDate": returnDate.date
        ]
        
        performSegue(withIdentifier: "selectSeat", sender: data)
    }
    
    //pass data to Seats
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectSeat" {
            if let destinationVC = segue.destination as? SeatsViewController,
               let data = sender as? [String: Any] {
                destinationVC.flightData = data
            }
        }
    }
    
    //Hides the return date if segmant name is oneway
    private func setupViewsFor(pagetype: PageType) {
        returnDate.isHidden = pagetype == .oneway
        returnDateLabel.isHidden = pagetype == .oneway
    }
    
    
    @IBAction func selectSourceCity(_ sender: Any) {
        openFlightViewController("sourcecity")
    }
    
    @IBAction func selectDestinationCity(_ sender: Any) {
        openFlightViewController("destinationcity")
    }
    
    //Handles segment change
    @IBAction func segmantControlChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            currentPageType = .oneway
        } else {
            currentPageType = .roundtrip
        }
    }
    
    
    func openFlightViewController(_ selectedTextfield: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let flightVC = storyboard.instantiateViewController(withIdentifier: "FlightTableViewController") as? FlightTableViewController {
            flightVC.selectedTextfield = selectedTextfield
            flightVC.selectedSourceCity = sourceCity.text
            flightVC.selectedDestinationCity = destinationCity.text
            flightVC.delegate = self
            self.navigationController?.pushViewController(flightVC, animated: true)
        }
    }

}
