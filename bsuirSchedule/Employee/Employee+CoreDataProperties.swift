//
//  Employee+CoreDataProperties.swift
//  Employee
//
//  Created by Andrej Hurynovič on 7.09.21.
//
//

import Foundation
import UIKit
import CoreData


extension Employee {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Employee> {
        let request = NSFetchRequest<Employee>(entityName: "Employee")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Employee.lastName, ascending: true)]
        return request
    }

    @NSManaged public var id: Int32
    @NSManaged public var urlID: String?
    @NSManaged public var firstName: String?
    @NSManaged public var middleName: String?
    @NSManaged public var lastName: String?
    
    @NSManaged public var rank: String?
    @NSManaged public var degree: String?
    @NSManaged public var departments: [String]?
    @NSManaged public var favorite: Bool
    
    @NSManaged public var educationStart: Date?
    @NSManaged public var educationEnd: Date?
    @NSManaged public var examsStart: Date?
    @NSManaged public var examsEnd: Date?
    
    @NSManaged public var photoLink: String?
    @NSManaged public var photo: Data?
    
    @NSManaged public var lessons: NSSet?

}

// MARK: Generated accessors for lessons
extension Employee {

    @objc(addLessonsObject:)
    @NSManaged public func addToLessons(_ value: Lesson)

    @objc(removeLessonsObject:)
    @NSManaged public func removeFromLessons(_ value: Lesson)

    @objc(addLessons:)
    @NSManaged public func addToLessons(_ values: NSSet)

    @objc(removeLessons:)
    @NSManaged public func removeFromLessons(_ values: NSSet)

}

extension Employee : Identifiable {

}
