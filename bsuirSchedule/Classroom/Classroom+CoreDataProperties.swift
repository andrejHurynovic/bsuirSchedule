//
//  Classroom+CoreDataProperties.swift
//  Classroom
//
//  Created by Andrej Hurynovič on 25.09.21.
//
//

import Foundation
import CoreData


extension Classroom {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Classroom> {
        let request = NSFetchRequest<Classroom>(entityName: "Classroom")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Classroom.name, ascending: true)]
        return request
    }

    @NSManaged public var floor: Int16
    @NSManaged public var name: String!
    @NSManaged public var originalName: String!
    @NSManaged public var favorite: Bool
    
    @NSManaged public var building: Int16
    
    @NSManaged public var typeValue: Int16
    
    @NSManaged public var departmentName: String?
    @NSManaged public var departmentAbbreviation: String?
    
    @NSManaged public var lessons: NSSet?
}

// MARK: Generated accessors for lessons
extension Classroom {

    @objc(addLessonsObject:)
    @NSManaged public func addToLessons(_ value: Lesson)

    @objc(removeLessonsObject:)
    @NSManaged public func removeFromLessons(_ value: Lesson)

    @objc(addLessons:)
    @NSManaged public func addToLessons(_ values: NSSet)

    @objc(removeLessons:)
    @NSManaged public func removeFromLessons(_ values: NSSet)

}

extension Classroom : Lessonable, Identifiable {
    var educationStart: Date? {
        groups().compactMap { $0.educationStart }.sorted().first
    }
    
    var educationEnd: Date? {
        groups().compactMap { $0.educationEnd }.sorted().last
    }
    
    var examsStart: Date? {
        groups().compactMap { $0.examsStart }.sorted().first
    }
    
    var examsEnd: Date? {
        groups().compactMap { $0.examsEnd }.sorted().last
    }
}
