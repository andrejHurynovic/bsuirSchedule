//
//  EducationType+CoreDataProperties.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 7.04.23.
//
//

import Foundation
import CoreData


extension EducationType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EducationType> {
        return NSFetchRequest<EducationType>(entityName: "EducationType")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String

}

//MARK: - Generated accessors for specialities
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

extension EducationType : Identifiable {}

//MARK: - Request

extension EducationType {
    static func getAll(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) -> [EducationType] {
        return try! context.fetch(self.fetchRequest())
    }
}
