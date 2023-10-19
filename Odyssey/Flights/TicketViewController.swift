//
//  TicketViewController.swift
//  Odyssey
//
//  Created by Rajwinder Singh on 10/15/23.
//

import UIKit

class TicketViewController: UIViewController, FlightDetailsDelegate {
    func flightNumber(_ number: String) {
        flightNumber.text = number
        print(number)
    }
    
    func flightSource(_ source: String) {
        sourceCity.text = source
    }
    
    func flightDestination(_ destination: String) {
        destinationCity.text = destination
    }
    
    func flightDepartureDate(_ departureDate: String) {
        self.departureDate.text = departureDate
    }
    
    func flightReturnDate(_ returnDate: String) {
        self.returnDate.text = returnDate
    }
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var ticketNumber: UITextField!
    @IBOutlet weak var flightNumber: UITextField!
    @IBOutlet weak var seatNumber: UITextField!
    @IBOutlet weak var sourceCity: UITextField!
    @IBOutlet weak var destinationCity: UITextField!
    @IBOutlet weak var departureDate: UITextField!
    @IBOutlet weak var returnDate: UITextField!
    @IBOutlet weak var ticketPrice: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Review Ticket"
        
        // Check the current view controller's identifier
        if let currentIdentifier = restorationIdentifier {
            if currentIdentifier == "TicketViewController" {
                // If the current view controller is "TicketViewController"
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                    barButtonSystemItem: .camera, target: self, action: nil)
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
    }
}
