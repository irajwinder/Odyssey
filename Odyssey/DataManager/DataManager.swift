//
//  DataManager.swift
//  Odyssey
//
//  Created by Rajwinder Singh on 10/18/23.
//

import Foundation
import CoreData
import UIKit

//Singleton Class
class DataManager: NSObject {
    static let sharedInstance: DataManager = {
        let instance = DataManager()
        return instance
    }()
    
    private override init() {
        super.init()
    }

    // Save user data to CoreData
    func saveUser(userName: String, userEmail: String, userDOB: Date, userCountry: String, userState: String, userCity: String) {
        // Obtains a reference to the AppDelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        // Accessing the managed context from the persistent container
        let managedContext = appDelegate.persistentContainer.viewContext

        //Create a newUser Object
        let newUser = User(context: managedContext)

        // Set the values for various attributes of the User entity
        newUser.userName = userName
        newUser.userEmail = userEmail

        let dateFormatter = DateFormatter() // Convert Date to String using DateFormatter
        dateFormatter.dateFormat = "MM/dd/yyyy" // Set date format
        let dateString = dateFormatter.string(from: userDOB)
        newUser.userDOB = dateString

        newUser.userCountry = userCountry
        newUser.userState = userState
        newUser.userCity = userCity
        
        do {
            // Attempting to save the changes made to the managed context
            try managedContext.save()
            print("User data saved successfully.")
        } catch let error as NSError {
            // Informs the user that an error occurred while saving the data.
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func updateUser(user: User, editUserName: String, editUserEmail: String, editUserDOB: Date, editUserCountry: String, editUserState: String, editUserCity: String) {
        // Obtains a reference to the AppDelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        // Accessing the managed context from the persistent container
        let managedContext = appDelegate.persistentContainer.viewContext

        // Update the user data
        user.userName = editUserName
        user.userEmail = editUserEmail
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        user.userDOB = dateFormatter.string(from: editUserDOB)
        user.userCountry = editUserCountry
        user.userState = editUserState
        user.userCity = editUserCity

        do {
            // Attempting to save the changes made to the managed context
            try managedContext.save()
            print("User data updated successfully.")
        } catch let error as NSError {
            // Informs the user that an error occurred while saving the data.
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    //Save the flight to Core Data
    func saveFlight(flightNumber: String, numberOfSeats: String, price: String, sourceCity: String, destinationCity: String, departureDate: Date, returnDate: String) {
        // Obtains a reference to the AppDelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        // Accessing the managed context from the persistent container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Create a newUser Object
        let newFlight = Flight(context: managedContext)
        
        // Set the values for various attributes of the Flight entity
        newFlight.flightNumber = flightNumber
        newFlight.totalSeats = numberOfSeats
        newFlight.isBooked = false
        newFlight.ticketPrice = price
        newFlight.source = sourceCity
        newFlight.destination = destinationCity
        
        let departureDateString = Validation.convertDateToString(date: departureDate, format: "MM/dd/yyyy")
        newFlight.departureDate = departureDateString
        newFlight.returnDate = returnDate
        
        do {
            // Attempting to save the changes made to the managed context
            try managedContext.save()
            print("Flight data saved successfully.")
        } catch let error as NSError {
            // Informs the user that an error occurred while saving the data.
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func updateFlight(flight: Flight, editFlightNumber: String, editNumberOfSeats: String, editPrice: String, editSourceCity: String, editDestinationCity: String, editDepartureDate: Date, editReturnDate: String) {
        // Obtains a reference to the AppDelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        // Accessing the managed context from the persistent container
        let managedContext = appDelegate.persistentContainer.viewContext

        // Update the flight data
        flight.flightNumber = editFlightNumber
        flight.totalSeats = editNumberOfSeats
        flight.ticketPrice = editPrice
        flight.source = editSourceCity
        flight.destination = editDestinationCity
        
        let departureDateString = Validation.convertDateToString(date: editDepartureDate, format: "MM/dd/yyyy")
        flight.departureDate = departureDateString
        flight.returnDate = editReturnDate

        do {
            // Attempting to save the changes made to the managed context
            try managedContext.save()
            print("Flight data updated successfully.")
        } catch let error as NSError {
            // Informs the user that an error occurred while saving the data.
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    //Save the ticket to Core Data
    func saveTicket(ticketNumber: String, userID: String, flightNumber: String, seatNumber: String) {
        // Obtains a reference to the AppDelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        // Accessing the managed context from the persistent container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Create a newTicket Object
        let newTicket = Ticket(context: managedContext)
        newTicket.ticketNumber = ticketNumber
        newTicket.userID = userID
        newTicket.flightNumber = flightNumber
        newTicket.seatNumber = seatNumber
        
        do {
            // Attempting to save the changes made to the managed context
            try managedContext.save()
            print("Ticket data saved successfully.")
        } catch let error as NSError {
            // Informs the user that an error occurred while saving the data.
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

}

let datamanagerInstance = DataManager.sharedInstance
