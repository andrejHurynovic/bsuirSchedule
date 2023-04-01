//
//  Department+CoreDataProperties.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 1.04.23.
//
//

import Foundation
import CoreData


extension Department {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Department> {
        return NSFetchRequest<Department>(entityName: "Department")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var abbreviation: String

    @NSManaged public var classrooms: NSSet?
    @NSManaged public var employees: NSSet?
    
}

// MARK: Generated accessors for employees
extension Department {
    
    @objc(addClassroomsObject:)
    @NSManaged public func addToClassrooms(_ value: Classroom)
    
    @objc(removeClassroomsObject:)
    @NSManaged public func removeFromClassrooms(_ value: Classroom)
    
    @objc(addClassrooms:)
    @NSManaged public func addToClassrooms(_ values: NSSet)
    
    @objc(removeClassrooms:)
    @NSManaged public func removeFromClassrooms(_ values: NSSet)
    
    @objc(addEmployeesObject:)
    @NSManaged public func addToEmployees(_ value: Department)
    
    @objc(removeEmployeesObject:)
    @NSManaged public func removeFromEmployees(_ value: Department)
    
    @objc(addEmployees:)
    @NSManaged public func addToEmployees(_ values: NSSet)
    
    @objc(removeEmployees:)
    @NSManaged public func removeFromEmployees(_ values: NSSet)
    
}

extension Department : Identifiable {}
