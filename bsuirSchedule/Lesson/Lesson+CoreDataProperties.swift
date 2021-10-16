//
//  Lesson+CoreDataProperties.swift
//  Lesson
//
//  Created by Andrej Hurynovič on 6.09.21.
//
//

import Foundation
import CoreData

enum LessonType: Int16 {
    case lecture = 0
    case practice = 1
    case laboratory = 2
}


extension Lesson {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Lesson> {
        let request = NSFetchRequest<Lesson>(entityName: "Lesson")
        request.sortDescriptors = []
        return request
    }
    
    @NSManaged public var subject: String?
    @NSManaged public var lessonTypeValue: Int16
    @NSManaged public var classroom: Classroom?
    
    @NSManaged public var groups: NSSet?
    @NSManaged public var subgroup: Int16
    
    @NSManaged public var weekNumber: [Int]?
    @NSManaged public var weekDay: Int16
    @NSManaged public var timeStart: String?
    @NSManaged public var timeEnd: String?
    
    @NSManaged public var employee: Employee?
    @NSManaged public var employeeID: Int32
    
}

// MARK: Generated accessors for groups
extension Lesson {

    @objc(addGroupsObject:)
    @NSManaged public func addToGroups(_ value: Group)

    @objc(removeGroupsObject:)
    @NSManaged public func removeFromGroups(_ value: Group)

    @objc(addGroups:)
    @NSManaged public func addToGroups(_ values: NSSet)

    @objc(removeGroups:)
    @NSManaged public func removeFromGroups(_ values: NSSet)

}

extension Lesson : Identifiable {
    var lessonType: LessonType {
        get {
            return LessonType(rawValue: self.lessonTypeValue)!
        }
        set {
            self.lessonTypeValue = newValue.rawValue
        }
    }
}
