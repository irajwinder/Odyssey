//
//  FlightsViewController.swift
//  Odyssey
//
//  Created by Rajwinder Singh on 10/12/23.
//

import UIKit

class FlightsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Flights"
        
        // Check the current view controller's identifier
        if let currentIdentifier = restorationIdentifier {
            if currentIdentifier == "FlightsViewController" {
                // If the current view controller is "SignUpForm"
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                    barButtonSystemItem: .save, target: self, action: nil)
            }
        }
    }

}
