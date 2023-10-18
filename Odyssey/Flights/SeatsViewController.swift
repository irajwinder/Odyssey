//
//  SeatsViewController.swift
//  Odyssey
//
//  Created by Rajwinder Singh on 10/15/23.
//

import UIKit

class SeatsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var seats: [Seat] = []

    // Populate the seats array with 50 seats
    func populateSeats() {
        let rows = ["A", "B", "C", "D", "E", "F"]
        for row in rows {
            for i in 1...10 {
                let seatNumber = "\(row)\(i)"
                let isBooked = Bool.random()
                seats.append(Seat(seatNumber: seatNumber, isBooked: isBooked))
            }
        }
    }

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
     
        populateSeats()
        collectionView.dataSource = self
        collectionView.delegate = self
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
        if !selectedSeat.isBooked {
            // Perform the booking action
            let alert = UIAlertController(title: "Seat Booking", message: "Do you want to book seat \(selectedSeat.seatNumber)?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Book", style: .default, handler: { _ in
                // Update the seat's status to booked
                self.seats[indexPath.item].isBooked = true
                // Reload the collection view to reflect the updated data
                self.collectionView.reloadData()
                print("Seat \(selectedSeat.seatNumber) booked.")
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Seat Booking", message: "Seat \(selectedSeat.seatNumber) is already booked.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

}
