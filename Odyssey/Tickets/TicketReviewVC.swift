//
//  TicketReviewVC.swift
//  Odyssey
//
//  Created by Rajwinder Singh on 10/15/23.
//

import UIKit

class TicketReviewVC: UIViewController {
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var ticketNumber: UITextField!
    @IBOutlet weak var flightNumber: UITextField!
    @IBOutlet weak var seatNumber: UITextField!
    @IBOutlet weak var sourceCity: UITextField!
    @IBOutlet weak var destinationCity: UITextField!
    @IBOutlet weak var departureDate: UITextField!
    @IBOutlet weak var returnDate: UITextField!
    @IBOutlet weak var ticketPrice: UITextField!
    
    var selectedUserName: String?
    var selectedFlightNumber: String?
    var selectedSeatNumber: String?
    var generatedTicketNumber: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Review Ticket"
        
        // Check the current view controller's identifier
        if let currentIdentifier = restorationIdentifier {
            if currentIdentifier == "TicketReviewVC" {
                // If the current view controller is "TicketReviewVC"
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                    barButtonSystemItem: .camera, target: self, action: #selector(printButton))
            }
        }
        
        
        //Disable editing of text fields
        userName.isEnabled = false
        ticketNumber.isEnabled = false
        flightNumber.isEnabled = false
        seatNumber.isEnabled = false
        sourceCity.isEnabled = false
        destinationCity.isEnabled = false
        departureDate.isEnabled = false
        returnDate.isEnabled = false
        ticketPrice.isEnabled = false
        
        
        if let userName = selectedUserName {
                self.userName.text = userName
            }
        if let flightNumber = selectedFlightNumber {
                self.flightNumber.text = flightNumber
            }
        if let seatNumber = selectedSeatNumber {
            self.seatNumber.text = seatNumber
        }
        if let ticketNumber = generatedTicketNumber {
            self.ticketNumber.text = ticketNumber
        }
    }
    
    @objc func printButton() {
        //Save and Print ticket
        
    }
}
