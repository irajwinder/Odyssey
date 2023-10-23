//
//  Ticket+CoreDataProperties.swift
//  Odyssey
//
//  Created by Rajwinder Singh on 10/23/23.
//
//

import Foundation
import CoreData


extension Ticket {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ticket> {
        return NSFetchRequest<Ticket>(entityName: "Ticket")
    }

    @NSManaged public var flightNumber: String?
    @NSManaged public var seatNumber: String?
    @NSManaged public var ticketNumber: String?
    @NSManaged public var userID: String?
    @NSManaged public var flight: Flight?
    @NSManaged public var user: User?

}

extension Ticket : Identifiable {

}
