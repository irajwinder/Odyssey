//
//  TicketsViewController.swift
//  Odyssey
//
//  Created by Rajwinder Singh on 10/12/23.
//

import UIKit

class TicketDetailsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Tickets"
        
        // Check the current view controller's identifier
        if let currentIdentifier = restorationIdentifier {
            if currentIdentifier == "TicketDetailsViewController" {
                // If the current view controller is "TicketDetailsViewController"
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                    barButtonSystemItem: .save, target: self, action: nil)
            }
        }
    }
}
