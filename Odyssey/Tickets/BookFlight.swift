//
//  BookFlight.swift
//  Odyssey
//
//  Created by Rajwinder Singh on 10/12/23.
//

import UIKit

class BookFlight: UIViewController, SelectUserDelegate, SelectFlightDelegate, SelectSeatDelegate {
    func didSelectUser(_ userName: String) {
        selectUserText.text = userName
    }
    
    func didSelectFlight(_ flightNumber: String) {
        selectFlightText.text = flightNumber
    }
    
    func didSelectSeat(_ seatNumber: String) {
        selectSeatText.text = seatNumber
    }
    
    @IBOutlet weak var selectUserText: UITextField!
    @IBOutlet weak var selectFlightText: UITextField!
    @IBOutlet weak var selectSeatText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Book Flight"
        
        // Check the current view controller's identifier
        if let currentIdentifier = restorationIdentifier {
            if currentIdentifier == "BookFlight" {
                // If the current view controller is "BookFlight"
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                    barButtonSystemItem: .save, target: self, action: #selector(saveButton))
            }
        }
        
        //Disable editing of text fields
        selectUserText.isEnabled = false
        selectFlightText.isEnabled = false
        selectSeatText.isEnabled = false
    }
    
    
    @IBAction func selectUser(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let userListVC = storyboard.instantiateViewController(withIdentifier: "UserListVC") as? UserListVC {
            userListVC.delegate = self
            self.navigationController?.pushViewController(userListVC, animated: true)
        }
    }
    
    @IBAction func selectFlight(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let flightListVC = storyboard.instantiateViewController(withIdentifier: "FlightListVC") as? FlightListVC {
            flightListVC.delegate = self
            self.navigationController?.pushViewController(flightListVC, animated: true)
        }

    }
    
    @IBAction func selectSeat(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let flightListVC = storyboard.instantiateViewController(withIdentifier: "SeatsVC") as? SeatsVC {
            flightListVC.delegate = self
            self.navigationController?.pushViewController(flightListVC, animated: true)
        }
    }
    
    
    @objc func saveButton() {
        //Validate before saving
        guard let userName = selectUserText.text, Validation.isValidName(userName) else {
            Validation.showAlert(on: self, with: "Error ", message: "Please select a User.")
            return
        }
        
        guard let userFlight = selectFlightText.text, Validation.isValidName(userFlight) else {
            Validation.showAlert(on: self, with: "Error ", message: "Please select a Flight.")
            return
        }
        
        guard let userSeat = selectSeatText.text, Validation.isValidName(userSeat) else {
            Validation.showAlert(on: self, with: "Error ", message: "Please select a Seat.")
            return
        }
        
        let ticketNumber = generateTicketNumber()
        print(ticketNumber)
        
        //Save a newTicket
        datamanagerInstance.saveTicket(
            ticketNumber: ticketNumber,
            userID: selectUserText.text ?? "",
            flightNumber: selectFlightText.text ?? "",
            seatNumber: selectSeatText.text ?? ""
        )
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let TicketsVC = storyboard.instantiateViewController(withIdentifier: "TicketsVC") as? TicketsVC {
            self.navigationController?.pushViewController(TicketsVC, animated: true)
        }
        
    }
    
    func generateTicketNumber() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        let dateString = formatter.string(from: Date())
        let randomSuffix = String(format: "%04d", arc4random_uniform(10000))
        return "TICKET-\(dateString)-\(randomSuffix)"
    }
}
