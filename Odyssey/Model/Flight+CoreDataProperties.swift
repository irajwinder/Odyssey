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

    @NSManaged public var departureDate: String?
    @NSManaged public var destination: String?
    @NSManaged public var flightNumber: Int64
    @NSManaged public var isBooked: Bool
    @NSManaged public var seatNumber: String?
    @NSManaged public var source: String?
    @NSManaged public var ticket: NSSet?

}

// MARK: Generated accessors for ticket
extension Flight {

    @objc(addTicketObject:)
    @NSManaged public func addToTicket(_ value: Ticket)

    @objc(removeTicketObject:)
    @NSManaged public func removeFromTicket(_ value: Ticket)

    @objc(addTicket:)
    @NSManaged public func addToTicket(_ values: NSSet)

    @objc(removeTicket:)
    @NSManaged public func removeFromTicket(_ values: NSSet)

}

extension Flight : Identifiable {

}
