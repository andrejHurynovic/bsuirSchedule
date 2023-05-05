//
//  Group.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 6.09.21.
//

import CoreData

extension Group {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Group> {
        let request = NSFetchRequest<Group>(entityName: "Group")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Group.name, ascending: true)]
        return request
    }
    
    @NSManaged public var name: String
    @NSManaged public var numberOfStudents: Int16
    @NSManaged public var educationDegreeValue: Int16
    @NSManaged public var course: Int16
    @NSManaged public var favorite: Bool
    @NSManaged public var lessonsUpdateDate: Date?
    
    @NSManaged public var nickname: String?
    
    @NSManaged public var speciality: Speciality?
    
    @NSManaged public var educationStart: Date?
    @NSManaged public var educationEnd: Date?
    @NSManaged public var examsStart: Date?
    @NSManaged public var examsEnd: Date?
    
    @NSManaged public var lessons: NSSet?
}

//MARK: - Generated accessors for lessons

extension Group {
    @objc(addLessonsObject:)
    @NSManaged public func addToLessons(_ value: Lesson)
    @objc(removeLessonsObject:)
    @NSManaged public func removeFromLessons(_ value: Lesson)
    @objc(addLessons:)
    @NSManaged public func addToLessons(_ values: NSSet)
    @objc(removeLessons:)
    @NSManaged public func removeFromLessons(_ values: NSSet)
}
