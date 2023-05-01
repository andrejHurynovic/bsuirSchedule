//
//  Lesson+CoreDataProperties.swift
//  Lesson
//
//  Created by Andrej Hurynovič on 6.09.21.
//
//

import CoreData

extension Lesson {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Lesson> {
        let request = NSFetchRequest<Lesson>(entityName: "Lesson")
        request.sortDescriptors = []
        return request
    }
    
    @NSManaged public var subject: String?
    @NSManaged public var abbreviation: String
    @NSManaged public var type: LessonType?
    @NSManaged public var note: String?
    
    @NSManaged public var dateString: String
    @NSManaged public var weekday: Int16
    @NSManaged public var weeks: [Int]
    @NSManaged public var startLessonDate: Date?
    @NSManaged public var startLessonDateString: String
    @NSManaged public var endLessonDate: Date?
    @NSManaged public var timeStart: String
    @NSManaged public var timeEnd: String
    
    @NSManaged public var groups: NSSet?
    @NSManaged public var subgroup: Int16
    @NSManaged public var auditories:  NSSet?
    @NSManaged public var auditoriesNames: [String]
    @NSManaged public var employees: NSSet?
    @NSManaged public var employeesIDs: [Int32]
    
}

//MARK: - Generated accessors for groups
extension Lesson {

    @objc(addGroupsObject:)
    @NSManaged public func addToGroups(_ value: Group)

    @objc(removeGroupsObject:)
    @NSManaged public func removeFromGroups(_ value: Group)

    @objc(addGroups:)
    @NSManaged public func addToGroups(_ values: NSSet)

    @objc(removeGroups:)
    @NSManaged public func removeFromGroups(_ values: NSSet)
    
    @objc(addEmployeesObject:)
    @NSManaged public func addToEmployees(_ value: Employee)

    @objc(removeEmployeesObject:)
    @NSManaged public func removeFromEmployees(_ value: Employee)

    @objc(addEmployees:)
    @NSManaged public func addToEmployees(_ values: NSSet)

    @objc(removeEmployees:)
    @NSManaged public func removeFromEmployees(_ values: NSSet)
    
    @objc(addAuditoriesObject:)
    @NSManaged public func addToAuditories(_ value: Auditorium)

    @objc(removeAuditoriesObject:)
    @NSManaged public func removeFromAuditories(_ value: Auditorium)

    @objc(addAuditories:)
    @NSManaged public func addToAuditories(_ values: NSSet)

    @objc(removeAuditories:)
    @NSManaged public func removeFromAuditories(_ values: NSSet)
}
