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

    @NSManaged public var auditoriums: NSSet?
    @NSManaged public var employees: NSSet?
    
}

//MARK: - Generated accessors for employees
extension Department {
    
    @objc(addAuditoriumsObject:)
    @NSManaged public func addToAuditoriums(_ value: Auditorium)
    
    @objc(removeAuditoriumsObject:)
    @NSManaged public func removeFromAuditoriums(_ value: Auditorium)
    
    @objc(addAuditoriums:)
    @NSManaged public func addToAuditoriums(_ values: NSSet)
    
    @objc(removeAuditoriums:)
    @NSManaged public func removeFromAuditoriums(_ values: NSSet)
    
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
