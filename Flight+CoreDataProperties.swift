//
//  Flight+CoreDataProperties.swift
//  Odyssey
//
//  Created by Rajwinder Singh on 10/13/23.
//
//

import Foundation
import CoreData


extension Flight {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Flight> {
        return NSFetchRequest<Flight>(entityName: "Flight")
    }

    @NSManaged public var departDate: String?
    @NSManaged public var flightType: String?
    @NSManaged public var from: String?
    @NSManaged public var to: String?
    @NSManaged public var user: UserInfo?

}

extension Flight : Identifiable {

}
