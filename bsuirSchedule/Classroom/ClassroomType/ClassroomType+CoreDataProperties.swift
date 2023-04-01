//
//  ClassroomType+CoreDataProperties.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 1.04.23.
//
//

import Foundation
import CoreData


extension ClassroomType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ClassroomType> {
        return NSFetchRequest<ClassroomType>(entityName: "ClassroomType")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String
    @NSManaged public var abbreviation: String
    
    @NSManaged public var classrooms: NSSet?

}

// MARK: Generated accessors for classrooms
extension ClassroomType {

    @objc(addClassroomsObject:)
    @NSManaged public func addToClassrooms(_ value: Classroom)

    @objc(removeClassroomsObject:)
    @NSManaged public func removeFromClassrooms(_ value: Classroom)

    @objc(addClassrooms:)
    @NSManaged public func addToClassrooms(_ values: NSSet)

    @objc(removeClassrooms:)
    @NSManaged public func removeFromClassrooms(_ values: NSSet)

}

extension ClassroomType : Identifiable {

}
