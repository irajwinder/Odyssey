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
                let isBooked = Bool.random() //generates random booked status
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
                print("Seat \(selectedSeat.seatNumber) selected.")
            } else {
                print("Seat \(selectedSeat.seatNumber) is already booked.")
            }
        }
}
