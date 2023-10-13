//
//  UserInfo+CoreDataProperties.swift
//  Odyssey
//
//  Created by Rajwinder Singh on 10/13/23.
//
//

import Foundation
import CoreData


extension UserInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserInfo> {
        return NSFetchRequest<UserInfo>(entityName: "User")
    }

    @NSManaged public var city: String?
    @NSManaged public var country: String?
    @NSManaged public var dateOfBirth: String?
    @NSManaged public var email: String?
    @NSManaged public var state: String?
    @NSManaged public var userName: String?
    @NSManaged public var flight: NSSet?

}

// MARK: Generated accessors for flight
extension UserInfo {

    @objc(addFlightObject:)
    @NSManaged public func addToFlight(_ value: Flight)

    @objc(removeFlightObject:)
    @NSManaged public func removeFromFlight(_ value: Flight)

    @objc(addFlight:)
    @NSManaged public func addToFlight(_ values: NSSet)

    @objc(removeFlight:)
    @NSManaged public func removeFromFlight(_ values: NSSet)

}

extension UserInfo : Identifiable {

}
