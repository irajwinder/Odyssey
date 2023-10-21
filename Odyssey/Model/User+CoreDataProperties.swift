//
//  User+CoreDataProperties.swift
//  Odyssey
//
//  Created by Rajwinder Singh on 10/21/23.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var userCity: String?
    @NSManaged public var userCountry: String?
    @NSManaged public var userDOB: String?
    @NSManaged public var userEmail: String?
    @NSManaged public var userName: String?
    @NSManaged public var userState: String?
    @NSManaged public var tickets: NSSet?

}

// MARK: Generated accessors for tickets
extension User {

    @objc(addTicketsObject:)
    @NSManaged public func addToTickets(_ value: Ticket)

    @objc(removeTicketsObject:)
    @NSManaged public func removeFromTickets(_ value: Ticket)

    @objc(addTickets:)
    @NSManaged public func addToTickets(_ values: NSSet)

    @objc(removeTickets:)
    @NSManaged public func removeFromTickets(_ values: NSSet)

}

extension User : Identifiable {

}
