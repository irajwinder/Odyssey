//
//  SeatsVC.swift
//  Odyssey
//
//  Created by Rajwinder Singh on 10/15/23.
//

import UIKit
import CoreData

protocol SelectSeatDelegate: AnyObject {
    func didSelectSeat(_ seatNumber: String)
}

class SeatsVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: SelectSeatDelegate?
    
    var flightNumber: String?
    var currentFlight: Flight?
    var seats: [Seat] = [] // Seats array
    var bookedSeats: Set<String> = Set()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Seats"
        
        // Check the current view controller's identifier
        if let currentIdentifier = restorationIdentifier {
            if currentIdentifier == "SeatsVC" {
                // If the current view controller is "SeatsVC"
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                    barButtonSystemItem: .save, target: self, action: #selector(saveButton))
            }
        }
        
        // Fetch the flight entity from Core Data
        guard let flightNumber = self.flightNumber else {
            return
        }

        //shows number of seats as per flight
        if let flight = datamanagerInstance.fetchNumberOfSeatsPerFlight(flightNumber: flightNumber) {
            currentFlight = flight

            if let numberOfSeats = Int(flight.totalSeats!) {
                for index in 1...numberOfSeats {
                    seats.append(Seat(seatNumber: "Seat \(index)", isBooked: false))
                }
            }
        }
        
        // Fetch the list of booked seats for the current flight
        if let flightNumber = self.flightNumber {
            if let bookedSeatsForFlight = datamanagerInstance.fetchBookedSeatsForFlight(flightNumber: flightNumber) {
                self.bookedSeats = bookedSeatsForFlight
            }
        }

        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    @objc func saveButton() {
        performSegue(withIdentifier: "AddUser", sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return seats.count
        }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SeatCell", for: indexPath) as! SeatsCollectionViewCell
        let seat = seats[indexPath.item]
        
        cell.seatLabel.text = seat.seatNumber
        cell.backgroundColor = bookedSeats.contains(seat.seatNumber) ? .red : .green
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedSeat = seats[indexPath.item]
        
        if bookedSeats.contains(selectedSeat.seatNumber) {
            // The seat is already booked, show an alert
            let alert = UIAlertController(title: "Seat Booking", message: "Seat \(selectedSeat.seatNumber) is already booked.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            // The seat is available, show a booking confirmation dialog
            let alert = UIAlertController(title: "Seat Booking", message: "Do you want to book seat \(selectedSeat.seatNumber)?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Book", style: .default, handler: { _ in
                // Update the seat's status to booked
                self.seats[indexPath.item].isBooked = true
                // Add the seat to the list of booked seats
                self.bookedSeats.insert(selectedSeat.seatNumber)
                // Reload the collection view to reflect the updated data
                self.collectionView.reloadData()
                
                // Pass the selected seat information to the delegate
                self.delegate?.didSelectSeat(selectedSeat.seatNumber)
                
                // Navigate back to the previous screen
                self.navigationController?.popViewController(animated: true)
                print("Seat \(selectedSeat.seatNumber) booked.")
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
