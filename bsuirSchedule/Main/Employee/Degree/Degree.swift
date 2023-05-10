//
//  Degree.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 10.05.23.
//

import CoreData

extension Degree {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Degree> {
        let request = NSFetchRequest<Degree>(entityName: "Degree")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Degree.abbreviation, ascending: true)]
        return request
    }

    @NSManaged public var abbreviation: String
    @NSManaged public var name: String?
    
    @NSManaged public var employees: NSSet?
}

// MARK: Generated accessors
extension Degree {
    @objc(addEmployeesObject:)
    @NSManaged public func addToEmployees(_ value: Employee)
    @objc(removeEmployeesObject:)
    @NSManaged public func removeFromEmployees(_ value: Employee)
    @objc(addEmployees:)
    @NSManaged public func addToEmployees(_ values: NSSet)
    @objc(removeEmployees:)
    @NSManaged public func removeFromEmployees(_ values: NSSet)
}
