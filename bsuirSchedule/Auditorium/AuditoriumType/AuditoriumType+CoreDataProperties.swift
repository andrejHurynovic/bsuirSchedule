//
//  AuditoriumType+CoreDataProperties.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 1.04.23.
//
//

import Foundation
import CoreData


extension AuditoriumType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AuditoriumType> {
        return NSFetchRequest<AuditoriumType>(entityName: "AuditoriumType")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String
    @NSManaged public var abbreviation: String
    
    @NSManaged public var auditoriums: NSSet?

}

//MARK: - Generated accessors for auditoriums
extension AuditoriumType {

    @objc(addAuditoriumsObject:)
    @NSManaged public func addToAuditoriums(_ value: Auditorium)

    @objc(removeAuditoriumsObject:)
    @NSManaged public func removeFromAuditoriums(_ value: Auditorium)

    @objc(addAuditoriums:)
    @NSManaged public func addToAuditoriums(_ values: NSSet)

    @objc(removeAuditoriums:)
    @NSManaged public func removeFromAuditoriums(_ values: NSSet)

}

extension AuditoriumType : Identifiable {

}
