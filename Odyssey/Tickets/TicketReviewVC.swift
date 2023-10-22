//
//  TicketReviewVC.swift
//  Odyssey
//
//  Created by Rajwinder Singh on 10/15/23.
//

import UIKit
import CoreData

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
    
    var ticket: Ticket?
    
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
        
        //Set the ticket info
        if let ticket = ticket {
            userName.text = ticket.userID
            ticketNumber.text = ticket.ticketNumber
            flightNumber.text = ticket.flightNumber
            seatNumber.text = ticket.seatNumber
            
            //Set Flight Info
            if let flight = fetchFlightDetails(flightNumber: ticket.flightNumber ?? "") {
                sourceCity.text = flight.source
                destinationCity.text = flight.destination
                departureDate.text = flight.departureDate
                returnDate.text = flight.returnDate
                ticketPrice.text = flight.ticketPrice
            }
        }
    }
    
    func fetchFlightDetails(flightNumber: String) -> Flight? {
        // Get a reference to the AppDelegate by accessing the shared instance of UIApplication
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        // Access the managed object context from the AppDelegate's persistent container.
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //fetch flight details from Core Data
        let fetchRequest = Flight.fetchRequest()
        //predicate to filter results based on the flight number
        fetchRequest.predicate = NSPredicate(format: "flightNumber == %@", flightNumber)
        
        do {
            let results = try managedContext.fetch(fetchRequest) 
            return results.first // Returning the first result, if any
        } catch let error as NSError {
            // Handling errors if the fetch request fails
            print("Could not fetch flight details. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    @objc func printButton() {
        //Print ticket
        createPDF()
    }
    
    func createPDF() {
        // Get the screen size of the device
        let screenSize = UIScreen.main.bounds.size

        // Create a PDF renderer with the screen size
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: screenSize))

        let data = pdfRenderer.pdfData { context in
            context.beginPage()

            // Calculate the scale factor to fit the content on the page
            let scaleFactor = min(screenSize.width / view.bounds.width, screenSize.height / view.bounds.height)

            // Apply the scale transformation
            context.cgContext.scaleBy(x: scaleFactor, y: scaleFactor)

            // Render the content to fit within the screen dimensions
            view.layer.render(in: context.cgContext)
        }

        // Save the PDF file to the documents directory
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let filePath = "\(documentsPath)/ticket.pdf"
        do {
            try data.write(to: URL(fileURLWithPath: filePath))
            print("PDF successfully saved at: \(filePath)")
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}
