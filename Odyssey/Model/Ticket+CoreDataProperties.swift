//
//  Ticket+CoreDataProperties.swift
//  Odyssey
//
//  Created by Rajwinder Singh on 10/21/23.
//
//

import Foundation
import CoreData


extension Ticket {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ticket> {
        return NSFetchRequest<Ticket>(entityName: "Ticket")
    }

    @NSManaged public var seatNumber: String?
    @NSManaged public var ticketNumber: String?
    @NSManaged public var flightNumber: String?
    @NSManaged public var userID: String?
    @NSManaged public var flight: NSSet?
    @NSManaged public var user: NSSet?

}

// MARK: Generated accessors for flight
extension Ticket {

    @objc(addFlightObject:)
    @NSManaged public func addToFlight(_ value: Flight)

    @objc(removeFlightObject:)
    @NSManaged public func removeFromFlight(_ value: Flight)

    @objc(addFlight:)
    @NSManaged public func addToFlight(_ values: NSSet)

    @objc(removeFlight:)
    @NSManaged public func removeFromFlight(_ values: NSSet)

}

// MARK: Generated accessors for user
extension Ticket {

    @objc(addUserObject:)
    @NSManaged public func addToUser(_ value: User)

    @objc(removeUserObject:)
    @NSManaged public func removeFromUser(_ value: User)

    @objc(addUser:)
    @NSManaged public func addToUser(_ values: NSSet)

    @objc(removeUser:)
    @NSManaged public func removeFromUser(_ values: NSSet)

}

extension Ticket : Identifiable {

}
