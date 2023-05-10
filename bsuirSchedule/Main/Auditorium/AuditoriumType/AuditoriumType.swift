//
//  AuditoriumType.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 1.04.23.
//

import CoreData

extension AuditoriumType {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<AuditoriumType> {
        let request = NSFetchRequest<AuditoriumType>(entityName: "AuditoriumType")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \AuditoriumType.id, ascending: true)]
        return request
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String
    @NSManaged public var abbreviation: String
    
    @NSManaged public var auditories: NSSet?
}

//MARK: - Generated accessors
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
