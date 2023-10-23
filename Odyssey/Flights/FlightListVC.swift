//
//  FlightListVC.swift
//  Odyssey
//
//  Created by Rajwinder Singh on 10/19/23.
//

import UIKit

protocol SelectFlightDelegate: AnyObject {
    func didSelectFlight(_ flightNumber: String)
}

class FlightListVC: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var flights: [Flight] = [] // Store the fetched flights
    
    @IBOutlet weak var flightListTableView: UITableView!
    
    weak var delegate: SelectFlightDelegate?

    var isComingFromCreateFlight = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Flight List"
        
        fetchFlights()
        flightListTableView.delegate = self
        flightListTableView.dataSource = self
    }
    
    // Fetch flight from Core Data
    func fetchFlights() {
        // Get a reference to the AppDelegate by accessing the shared instance of UIApplication
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        // Access the managed object context from the AppDelegate's persistent container.
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            //fetch the flight based on the fetch request
            self.flights = try managedContext.fetch(Flight.fetchRequest())
            self.flightListTableView.reloadData()
        } catch let error as NSError {
            // Handle the error
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    // Delete flight from Core Data
    func deleteFlight(at indexPath: IndexPath) {
        // Get a reference to the AppDelegate by accessing the shared instance of UIApplication
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        // Access the managed object context from the AppDelegate's persistent container.
        let managedContext = appDelegate.persistentContainer.viewContext
        // Delete the flight at the specified indexPath from the managed context.
        managedContext.delete(flights[indexPath.row])

        do {
            //save the changes made to the managed context.
            try managedContext.save()
            print("Flight deleted successfully.")
        } catch let error as NSError {
            // Handle the error
            print("Could not delete. \(error), \(error.userInfo)")
        }
        fetchFlights()
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flights.count // Return the count of fetched flights
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "FlightListCell", for: indexPath) as! FlightListTableViewCell
        
        let flight = flights[indexPath.row]
        if let flightName = flight.value(forKeyPath: "flightNumber") as? String {
            cell.flightLabel.text = flightName
        }
        if let flightSeat = flight.value(forKeyPath: "totalSeats") as? String {
            cell.seatsLabel.text = flightSeat
        }
        if let flightSource = flight.value(forKeyPath: "source") as? String {
            cell.sourceLabel.text = flightSource
        }
        if let flightDestination = flight.value(forKeyPath: "destination") as? String {
            cell.destinationLabel.text = flightDestination
        }
        if let flightDepartureDate = flight.value(forKeyPath: "departureDate") as? String {
            cell.departureDateLabel.text = flightDepartureDate
        }
        if let flightReturnDate = flight.value(forKeyPath: "returnDate") as? String {
            cell.returnDateLabel.text = flightReturnDate
        }

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteFlight(at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFlight = flights[indexPath.row].flightNumber
        
        // Calls the delegate method to pass the selected data back to ViewController
        if let flight = selectedFlight {
            delegate?.didSelectFlight(flight)
            
        }
        
        if isComingFromCreateFlight {
            performSegue(withIdentifier: "FlightListToEditFlight", sender: nil)
        } else {
            // Navigate back to the previous screen
            navigationController?.popViewController(animated: true)
        }
    }
    
    //Pass user data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FlightListToEditFlight" {
            if let indexPath = flightListTableView.indexPathForSelectedRow {
                // Get the selected user
                let selectedFlight = flights[indexPath.row]
                
                // Pass the selected user to the destination view controller
                if let destinationVC = segue.destination as? EditFlightVC {
                    destinationVC.flight = selectedFlight
                }
            }
        }
    }
    
}
