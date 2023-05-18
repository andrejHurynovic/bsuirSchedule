//
//  Faculty.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 21.09.21.
//

import CoreData

extension Faculty {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Faculty> {
        let request = NSFetchRequest<Faculty>(entityName: "Faculty")
        request.sortDescriptors = []
        return request
    }
    
    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var abbreviation: String?
    
    @NSManaged public var specialities: NSSet?
}

//MARK: - Generated accessors

extension Faculty {
    @objc(addSpecialitiesObject:)
    @NSManaged public func addToSpecialities(_ value: Speciality)
    @objc(removeSpecialitiesObject:)
    @NSManaged public func removeFromSpecialities(_ value: Speciality)
    @objc(addSpecialities:)
    @NSManaged public func addToSpecialities(_ values: NSSet)
    @objc(removeSpecialities:)
    @NSManaged public func removeFromSpecialities(_ values: NSSet)
    
}
