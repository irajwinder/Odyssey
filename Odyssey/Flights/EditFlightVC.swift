//
//  EditFlightVC.swift
//  Odyssey
//
//  Created by Rajwinder Singh on 10/21/23.
//

import UIKit

protocol EditFlightDelegate: AnyObject {
    func didUpdateFlight()
}

class EditFlightVC: UIViewController, CitySelectionDelegate {
    func didSelectSourceCity(_ source: String) {
        //Updates the text fields
        editSource.text = source
    }
    
    func didSelectDestinationCity(_ destination: String) {
        editDestination.text = destination
    }
    
    @IBOutlet weak var editFlightNumber: UITextField!
    @IBOutlet weak var editNumberOfSeats: UITextField!
    @IBOutlet weak var editPrice: UITextField!
    @IBOutlet weak var editSource: UITextField!
    @IBOutlet weak var editDestination: UITextField!
    @IBOutlet weak var editDepartureDate: UIDatePicker!
    
    @IBOutlet weak var editReturnDateLabel: UILabel!
    @IBOutlet weak var editReturnDate: UIDatePicker!
    
    @IBOutlet weak var editSegmentControl: UISegmentedControl!
    
    var flight: Flight?
    var isEditingEnabled = false
    weak var delegate: EditFlightDelegate?
    
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
        navigationItem.title = "Edit Flight Details"
        
        // Check the current view controller's identifier
        if let currentIdentifier = restorationIdentifier {
            if currentIdentifier == "EditFlightVC" {
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

        //By default segmant oneway
        setupViewsFor(pagetype: .oneway)
        
        //Disable editing of text fields
        editFlightNumber.isEnabled = isEditingEnabled
        editNumberOfSeats.isEnabled = isEditingEnabled
        editPrice.isEnabled = isEditingEnabled
        editSource.isEnabled = isEditingEnabled
        editDestination.isEnabled = isEditingEnabled
        editDepartureDate.isEnabled = isEditingEnabled
        editReturnDate.isEnabled = isEditingEnabled
        
        //Set the flight info
        if let flight = flight {
            editFlightNumber.text = flight.flightNumber
            editNumberOfSeats.text = flight.totalSeats
            editPrice.text = flight.ticketPrice
            editSource.text = flight.source
            editDestination.text = flight.destination
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            if let date = dateFormatter.date(from: flight.departureDate ?? "nil") {
                editDepartureDate.date = date
            } else {
                //date conversion fails
                print("Failed to convert Departure Date to Date.")
            }
            if let returnDate = dateFormatter.date(from: flight.returnDate ?? "nil") {
                editReturnDate.date = returnDate
            } else {
                //date conversion fails
                print("Failed to convert Return Date to Date.")
            }
        }
    
    }
    
    //Hides the return date if segmant name is oneway
    private func setupViewsFor(pagetype: PageType) {
        editReturnDate.isHidden = pagetype == .oneway
        editReturnDateLabel.isHidden = pagetype == .oneway
    }
    
    @IBAction func editSourceCity(_ sender: Any) {
        if isEditingEnabled {
            openFlightViewController("sourcecity")
        }
    }
    
    @IBAction func editDestinationCity(_ sender: Any) {
        if isEditingEnabled {
            openFlightViewController("destinationcity")
        }
    }
    
    func openFlightViewController(_ selectedTextfield: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let flightVC = storyboard.instantiateViewController(withIdentifier: "CitiesTableVC") as? CitiesTableVC {
            flightVC.selectedTextfield = selectedTextfield
            flightVC.selectedSourceCity = editSource.text
            flightVC.selectedDestinationCity = editDestination.text
            flightVC.delegate = self
            self.navigationController?.pushViewController(flightVC, animated: true)
        }
    }
        
    @IBAction func segmantControlChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            currentPageType = .oneway
        } else {
            currentPageType = .roundtrip
        }
        
    }
    
    
    @objc func editButton() {
        //Enable editing and change button to "Save"
        isEditingEnabled = true
        viewDidLoad() // Refresh the view to apply changes
    }
    
    //Upadate the flight to Core Data
    @objc func saveButton() {
        //Validate before saving
        guard let flightNumberText = editFlightNumber.text, Validation.isValidFlight(flightNumberText) else {
            Validation.showAlert(on: self, with: "Invalid Flight Number", message: "Please enter a valid Flight Number.")
            return
        }
        
        guard let seatNumberText = editNumberOfSeats.text, Validation.isValidSeat(Int(seatNumberText)) else {
            Validation.showAlert(on: self, with: "Invalid Seats Number", message: "Please enter a valid Seats Number.")
            return
        }
        
        guard let ticketPriceText = editPrice.text, Validation.isValidSeat(Int(ticketPriceText)) else {
            Validation.showAlert(on: self, with: "Invalid Ticket Price", message: "Please enter a valid Price.")
            return
        }
        
        guard let sourceCityText = editSource.text, Validation.isValidCity(sourceCityText) else {
            Validation.showAlert(on: self, with: "Invalid City", message: "Please enter a valid Source City.")
            return
        }
        
        guard let destinationCityText = editDestination.text, Validation.isValidState(destinationCityText) else {
            Validation.showAlert(on: self, with: "Invalid City", message: "Please enter a valid Destination City.")
            return
        }
        
        let departureDateText = editDepartureDate.date
        guard Validation.isValidDepartureDate(departureDateText) else {
            Validation.showAlert(on: self, with: "Invalid Date", message: "Date must be greater than today's date.")
            return
        }
        
        if currentPageType == .roundtrip {
            let returnDateText = editReturnDate.date
            guard Validation.isValidReturnDate(returnDateText, departureDate: departureDateText) else {
                Validation.showAlert(on: self, with: "Invalid Date", message: "Return date must be after departure date")
                return
            }
        }
        // Save changes and disable editing
        isEditingEnabled = false
        
        guard let flight = flight else {
            // Handle the case when the flight object is nil
            print("Error: Flight object is nil.")
            return
        }
        
        //Convert date to string
        let returnDateString = Validation.convertDateToString(date: self.editReturnDate.date, format: "MM/dd/yyyy")
        datamanagerInstance.updateFlight(
            flight: flight,
            editFlightNumber: self.editFlightNumber.text ?? "",
            editNumberOfSeats: self.editNumberOfSeats.text ?? "",
            editPrice: self.editPrice.text ?? "",
            editSourceCity: self.editSource.text ?? "",
            editDestinationCity: self.editDestination.text ?? "",
            editDepartureDate: self.editDepartureDate.date,
            editReturnDate: returnDateString
        )
        // Call delegate method
        delegate?.didUpdateFlight()
        navigationController?.popViewController(animated: true)
    }
}
