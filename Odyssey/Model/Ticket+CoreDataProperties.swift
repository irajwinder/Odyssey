//
//  Ticket+CoreDataProperties.swift
//  Odyssey
//
//  Created by Rajwinder Singh on 10/18/23.
//
//

import Foundation
import CoreData


extension Ticket {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ticket> {
        return NSFetchRequest<Ticket>(entityName: "Ticket")
    }

    @NSManaged public var ticketNumber: Int64
    @NSManaged public var ticketPrice: Int64
    @NSManaged public var flight: Flight?
    @NSManaged public var user: User?

}

extension Ticket : Identifiable {

}
