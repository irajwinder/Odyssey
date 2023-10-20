//
//  Flight+CoreDataProperties.swift
//  Odyssey
//
//  Created by Rajwinder Singh on 10/19/23.
//
//

import Foundation
import CoreData


extension Flight {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Flight> {
        return NSFetchRequest<Flight>(entityName: "Flight")
    }

    @NSManaged public var destination: String?
    @NSManaged public var flightNumber: String?
    @NSManaged public var source: String?
    @NSManaged public var departureDate: String?
    @NSManaged public var returnDate: String?
    @NSManaged public var seatNumber: String?
    @NSManaged public var isBooked: Bool
    @NSManaged public var ticketPrice: String?

}

extension Flight : Identifiable {

}
