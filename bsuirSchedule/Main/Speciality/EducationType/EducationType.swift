//
//  EducationType.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 7.04.23.
//
//

import CoreData

extension EducationType {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<EducationType> {
        let request = NSFetchRequest<EducationType>(entityName: "EducationType")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \EducationType.id, ascending: true)]
        return request
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String
}

//MARK: - Generated accessors for EducationType

extension EducationType {
    @objc(addSpecialitiesObject:)
    @NSManaged public func addToSpecialities(_ value: Speciality)
    
    @objc(removeSpecialitiesObject:)
    @NSManaged public func removeFromSpecialities(_ value: Speciality)
    
    @objc(addSpecialities:)
    @NSManaged public func addToSpecialities(_ values: NSSet)
    
    @objc(removeSpecialities:)
    @NSManaged public func removeFromSpecialities(_ values: NSSet)
}
