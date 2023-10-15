//
//  SeatsViewController.swift
//  Odyssey
//
//  Created by Rajwinder Singh on 10/15/23.
//

import UIKit

class SeatsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Seats"
        
        // Check the current view controller's identifier
        if let currentIdentifier = restorationIdentifier {
            if currentIdentifier == "SeatsViewController" {
                // If the current view controller is "SeatsViewController"
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                    barButtonSystemItem: .save, target: self, action: nil)
            }
        }
    }
}
