//
//  TicketViewController.swift
//  Odyssey
//
//  Created by Rajwinder Singh on 10/15/23.
//

import UIKit

class TicketViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Review Ticket"
        
        // Check the current view controller's identifier
        if let currentIdentifier = restorationIdentifier {
            if currentIdentifier == "TicketViewController" {
                // If the current view controller is "TicketViewController"
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                    barButtonSystemItem: .save, target: self, action: nil)
            }
        }
    }
}
