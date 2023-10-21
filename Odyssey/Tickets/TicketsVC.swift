//
//  TicketsVC.swift
//  Odyssey
//
//  Created by Rajwinder Singh on 10/21/23.
//

import UIKit

class TicketsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var ticketsListTableView: UITableView!
    
    var tickets: [Ticket] = [] // Store the fetched tickets

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Ticket List"
        
        // Check the current view controller's identifier
        if let currentIdentifier = restorationIdentifier {
            if currentIdentifier == "TicketsVC" {
                // If the current view controller is "FlightVC"
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                    barButtonSystemItem: .add, target: self, action: #selector(addButton))
            }
        }
        
        fetchTickets()
        ticketsListTableView.delegate = self
        ticketsListTableView.dataSource = self
    }
    
    //add the ticket to Core Data
    @objc func addButton() {
        performSegue(withIdentifier: "TicketListToBookTicket", sender: nil)
    }
    
    // Fetch Tickets from Core Data
    func fetchTickets() {
        // Get a reference to the AppDelegate by accessing the shared instance of UIApplication
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        // Access the managed object context from the AppDelegate's persistent container.
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            //fetch the tickets based on the fetch request
            self.tickets = try managedContext.fetch(Ticket.fetchRequest())
            self.ticketsListTableView.reloadData()
        } catch let error as NSError {
            // Handle the error
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    // Delete ticket from Core Data
    func deleteTicket(at indexPath: IndexPath) {
        // Get a reference to the AppDelegate by accessing the shared instance of UIApplication
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        // Access the managed object context from the AppDelegate's persistent container.
        let managedContext = appDelegate.persistentContainer.viewContext
        // Delete the ticket at the specified indexPath from the managed context.
        managedContext.delete(tickets[indexPath.row])

        do {
            //save the changes made to the managed context.
            try managedContext.save()
            print("Ticket deleted successfully.")
        } catch let error as NSError {
            // Handle the error
            print("Could not delete. \(error), \(error.userInfo)")
        }
        fetchTickets()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tickets.count // Return the count of fetched tickets
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "TicketsCell", for: indexPath) as! TicketsTableViewCell
        
        let ticket = tickets[indexPath.row]
        if let ticketNumber = ticket.value(forKeyPath: "ticketNumber") as? String {
            cell.ticketNumbers.text = ticketNumber
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteTicket(at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "TicketsToTicketReview", sender: nil)
    }
    
    //Pass ticket data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TicketsToTicketReview" {
            if let indexPath = ticketsListTableView.indexPathForSelectedRow {
                // Get the selected ticket
                let selectedTicket = tickets[indexPath.row]
                
                // Pass the selected ticket to the destination view controller
                if let destinationVC = segue.destination as? TicketReviewVC {
                    destinationVC.ticket = selectedTicket
                }
            }
        }
    }
    
}
