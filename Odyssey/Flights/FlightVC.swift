//
//  FlightVC.swift
//  Odyssey
//
//  Created by Rajwinder Singh on 10/12/23.
//

import UIKit

class FlightVC: UIViewController, CitySelectionDelegate {
    func didSelectSourceCity(_ source: String) {
        //Updates the text fields
        sourceCity.text = source
    }
    
    func didSelectDestinationCity(_ destination: String) {
        destinationCity.text = destination
    }
    
    @IBOutlet weak var flightNumber: UITextField!
    @IBOutlet weak var numberOfSeats: UITextField!
    @IBOutlet weak var price: UITextField!
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
            if currentIdentifier == "FlightVC" {
                // If the current view controller is "FlightVC"
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
    
    func openFlightViewController(_ selectedTextfield: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let flightVC = storyboard.instantiateViewController(withIdentifier: "CitiesTableVC") as? CitiesTableVC {
            flightVC.selectedTextfield = selectedTextfield
            flightVC.selectedSourceCity = sourceCity.text
            flightVC.selectedDestinationCity = destinationCity.text
            flightVC.delegate = self
            self.navigationController?.pushViewController(flightVC, animated: true)
        }
    }
    
    //Handles segment change
    @IBAction func segmantControlChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            currentPageType = .oneway
        } else {
            currentPageType = .roundtrip
        }
    }
    
    //Save the flight to Core Data
    @objc func saveButton() {
        //Validate before saving
        guard let flightNumberText = flightNumber.text, Validation.isValidFlight(flightNumberText) else {
            Validation.showAlert(on: self, with: "Invalid Flight Number", message: "Please enter a valid Flight Number.")
            return
        }
        
        guard let seatNumberText = numberOfSeats.text, Validation.isValidSeat(Int(seatNumberText)) else {
            Validation.showAlert(on: self, with: "Invalid Seats Number", message: "Please enter a valid Seats Number.")
            return
        }
        
        guard let ticketPriceText = price.text, Validation.isValidSeat(Int(ticketPriceText)) else {
            Validation.showAlert(on: self, with: "Invalid Ticket Price", message: "Please enter a valid Price.")
            return
        }
        
        guard let sourceCityText = sourceCity.text, Validation.isValidCity(sourceCityText) else {
            Validation.showAlert(on: self, with: "Invalid City", message: "Please enter a valid Source City.")
            return
        }
        
        guard let destinationCityText = destinationCity.text, Validation.isValidState(destinationCityText) else {
            Validation.showAlert(on: self, with: "Invalid City", message: "Please enter a valid Destination City.")
            return
        }
        
        let departureDateText = departureDate.date
        guard Validation.isValidDepartureDate(departureDateText) else {
            Validation.showAlert(on: self, with: "Invalid Date", message: "Date must be greater than today's date.")
            return
        }
        
        if currentPageType == .roundtrip {
            let returnDateText = returnDate.date
            guard Validation.isValidReturnDate(returnDateText, departureDate: departureDateText) else {
                Validation.showAlert(on: self, with: "Invalid Date", message: "Return date must be after departure date")
                return
            }
        }
        //Convert date to string
        let returnDateString = Validation.convertDateToString(date: self.returnDate.date, format: "MM/dd/yyyy")
        
        //save flight data using datamanagerInstance
        if currentPageType == .oneway {
            datamanagerInstance.saveFlight(
                flightNumber: self.flightNumber.text ?? "",
                numberOfSeats: self.numberOfSeats.text ?? "",
                price: self.price.text ?? "",
                sourceCity: self.sourceCity.text ?? "",
                destinationCity: self.destinationCity.text ?? "",
                departureDate: self.departureDate.date,
                returnDate: "No return flight"
            )
        } else {
            datamanagerInstance.saveFlight(
                flightNumber: self.flightNumber.text ?? "",
                numberOfSeats: self.numberOfSeats.text ?? "",
                price: self.price.text ?? "",
                sourceCity: self.sourceCity.text ?? "",
                destinationCity: self.destinationCity.text ?? "",
                departureDate: self.departureDate.date,
                returnDate: returnDateString
            )
        }
        // Instantiate the FlightListVC from the storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let flightListVC = storyboard.instantiateViewController(withIdentifier: "FlightListVC") as? FlightListVC {
            // Push the FlightListVC onto the navigation stack
            self.navigationController?.pushViewController(flightListVC, animated: true)
        }
    }
}
