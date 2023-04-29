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
    
    @NSManaged public var auditories: NSSet?

}

//MARK: - Generated accessors for auditories
extension AuditoriumType {

    @objc(addAuditoriesObject:)
    @NSManaged public func addToAuditories(_ value: Auditorium)

    @objc(removeAuditoriesObject:)
    @NSManaged public func removeFromAuditories(_ value: Auditorium)

    @objc(addAuditories:)
    @NSManaged public func addToAuditories(_ values: NSSet)

    @objc(removeAuditories:)
    @NSManaged public func removeFromAuditories(_ values: NSSet)

}

extension AuditoriumType : Identifiable {

}
