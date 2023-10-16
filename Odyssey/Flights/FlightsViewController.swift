//
//  FlightsViewController.swift
//  Odyssey
//
//  Created by Rajwinder Singh on 10/12/23.
//

import UIKit

class FlightsViewController: UIViewController, LocationSelectionDelegate {
    
    func didSelectLocation(_ location: String) {
        // Handle the location selection and update the userCountry text field.
        //userCountry.text = location
       }
    
    
    @IBOutlet weak var souceCity: UITextField!
    @IBOutlet weak var destinationCity: UITextField!
    @IBOutlet weak var departureDate: UITextField!
    @IBOutlet weak var returnDate: UITextField!
    @IBOutlet weak var returnDateLabel: UILabel!
    @IBOutlet weak var segmantControl: UISegmentedControl!
    
    
    private enum PageType {
        case oneway
        case roundtrip
    }
    
    private var currentPageType: PageType = .oneway {
        didSet {
            setupViewsFor(pagetype: currentPageType)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Flights"
        
        // Check the current view controller's identifier
        if let currentIdentifier = restorationIdentifier {
            if currentIdentifier == "FlightsViewController" {
                // If the current view controller is "SignUpForm"
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                    barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
            }
        }
        
        setupViewsFor(pagetype: .oneway)
    }
    
    @objc func saveButtonTapped() {
        performSegue(withIdentifier: "selectSeat", sender: nil) // Make sure to set the segue identifier in the storyboard
    }
    
    //Hides the return date if segmant name is oneway
    private func setupViewsFor(pagetype: PageType) {
        returnDate.isHidden = pagetype == .oneway
        returnDateLabel.isHidden = pagetype == .oneway
    }
    
    
    @IBAction func selectSourceCity(_ sender: Any) {
        openLocationViewController("city")
    }
    
    @IBAction func selectDestinationCity(_ sender: Any) {
        openLocationViewController("city")
    }
    
    //Handles segment change
    @IBAction func segmantControlChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            currentPageType = .oneway
        } else {
            currentPageType = .roundtrip
        }
    }
    
    
    func openLocationViewController(_ selectedTextfield: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let locationVC = storyboard.instantiateViewController(withIdentifier: "LocationViewController") as? LocationViewController {
            locationVC.selectedTextfield = selectedTextfield
            locationVC.delegate = self
            self.navigationController?.pushViewController(locationVC, animated: true)
        }
    }

}
