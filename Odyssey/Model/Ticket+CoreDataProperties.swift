//
//  Ticket+CoreDataProperties.swift
//  Odyssey
//
//  Created by Rajwinder Singh on 10/19/23.
//
//

import Foundation
import CoreData


extension Ticket {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ticket> {
        return NSFetchRequest<Ticket>(entityName: "Ticket")
    }

    @NSManaged public var ticketPrice: Int64
    @NSManaged public var user: NSSet?

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
