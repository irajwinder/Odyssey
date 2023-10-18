//
//  Flight+CoreDataProperties.swift
//  Odyssey
//
//  Created by Rajwinder Singh on 10/18/23.
//
//

import Foundation
import CoreData


extension Flight {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Flight> {
        return NSFetchRequest<Flight>(entityName: "Flight")
    }

    @NSManaged public var departureDate: String?
    @NSManaged public var destination: String?
    @NSManaged public var flightNumber: Int64
    @NSManaged public var isBooked: Bool
    @NSManaged public var seatNumber: String?
    @NSManaged public var source: String?
    @NSManaged public var passengers: User?
    @NSManaged public var ticket: Ticket?

}

extension Flight : Identifiable {

}
