//
//  SeatsViewController.swift
//  Odyssey
//
//  Created by Rajwinder Singh on 10/15/23.
//

import UIKit

protocol SeatDetails: AnyObject {
    func seatNumber(_ number: String)
}

class SeatsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var flightData: [String: Any]?
    
    // Seats array with 50 static seats
    var seats: [Seat] = [
        Seat(seatNumber: "A1", isBooked: false),
        Seat(seatNumber: "A2", isBooked: false),
        Seat(seatNumber: "A3", isBooked: false),
        Seat(seatNumber: "A4", isBooked: false),
        Seat(seatNumber: "A5", isBooked: false),
        Seat(seatNumber: "A6", isBooked: false),
        Seat(seatNumber: "A7", isBooked: false),
        Seat(seatNumber: "A8", isBooked: false),
        Seat(seatNumber: "A9", isBooked: false),
        Seat(seatNumber: "A10", isBooked: false),
        Seat(seatNumber: "B1", isBooked: false),
        Seat(seatNumber: "B2", isBooked: false),
        Seat(seatNumber: "B3", isBooked: false),
        Seat(seatNumber: "B4", isBooked: false),
        Seat(seatNumber: "B5", isBooked: false),
        Seat(seatNumber: "B6", isBooked: false),
        Seat(seatNumber: "B7", isBooked: false),
        Seat(seatNumber: "B8", isBooked: false),
        Seat(seatNumber: "B9", isBooked: false),
        Seat(seatNumber: "B10", isBooked: false),
        Seat(seatNumber: "C1", isBooked: false),
        Seat(seatNumber: "C2", isBooked: false),
        Seat(seatNumber: "C3", isBooked: false),
        Seat(seatNumber: "C4", isBooked: false),
        Seat(seatNumber: "C5", isBooked: false),
        Seat(seatNumber: "C6", isBooked: false),
        Seat(seatNumber: "C7", isBooked: false),
        Seat(seatNumber: "C8", isBooked: false),
        Seat(seatNumber: "C9", isBooked: false),
        Seat(seatNumber: "C10", isBooked: false),
        Seat(seatNumber: "D1", isBooked: false),
        Seat(seatNumber: "D2", isBooked: false),
        Seat(seatNumber: "D3", isBooked: false),
        Seat(seatNumber: "D4", isBooked: false),
        Seat(seatNumber: "D5", isBooked: false),
        Seat(seatNumber: "D6", isBooked: false),
        Seat(seatNumber: "D7", isBooked: false),
        Seat(seatNumber: "D8", isBooked: false),
        Seat(seatNumber: "D9", isBooked: false),
        Seat(seatNumber: "D10", isBooked: false),
        Seat(seatNumber: "E1", isBooked: false),
        Seat(seatNumber: "E2", isBooked: false),
        Seat(seatNumber: "E3", isBooked: false),
        Seat(seatNumber: "E4", isBooked: false),
        Seat(seatNumber: "E5", isBooked: false),
        Seat(seatNumber: "E6", isBooked: false),
        Seat(seatNumber: "E7", isBooked: false),
        Seat(seatNumber: "E8", isBooked: false),
        Seat(seatNumber: "E9", isBooked: false),
        Seat(seatNumber: "E10", isBooked: false),
        Seat(seatNumber: "F1", isBooked: false),
        Seat(seatNumber: "F2", isBooked: false),
        Seat(seatNumber: "F3", isBooked: false),
        Seat(seatNumber: "F4", isBooked: false),
        Seat(seatNumber: "F5", isBooked: false),
        Seat(seatNumber: "F6", isBooked: false),
        Seat(seatNumber: "F7", isBooked: false),
        Seat(seatNumber: "F8", isBooked: false),
        Seat(seatNumber: "F9", isBooked: false),
        Seat(seatNumber: "F10", isBooked: false)
    ]

    var bookedSeats: Set<String> = Set()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Seats"
        
        // Check the current view controller's identifier
        if let currentIdentifier = restorationIdentifier {
            if currentIdentifier == "SeatsViewController" {
                // If the current view controller is "SeatsViewController"
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                    barButtonSystemItem: .save, target: self, action: #selector(saveButton))
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SeatCell", for: indexPath) as! CollectionViewCell
        let seat = seats[indexPath.item]
        
        cell.seatLabel.text = seat.seatNumber
        cell.backgroundColor = seat.isBooked ? .red : .green
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
                print("Seat \(selectedSeat.seatNumber) booked.")
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        print(bookedSeats)
    }



}
