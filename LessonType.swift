//
//  LessonType.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 1.05.23.
//
//

import CoreData
import SwiftUI

extension LessonType {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<LessonType> {
        let request = NSFetchRequest<LessonType>(entityName: "LessonType")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \LessonType.id, ascending: true)]
        return request
    }

    @NSManaged public var id: String
    
    @NSManaged public var name: String?
    @NSManaged public var abbreviation: String?
    
    @NSManaged var colorData: Data?
    
    @NSManaged public var lessons: NSSet?
}

extension LessonType {
    var color: Color? {
        get {
            guard let data = colorData else { return nil }
            return Color(rawValue: data)
        }
        set { colorData = newValue?.rawValue }
    }
    
}
extension LessonType {
    @objc(addGroupsObject:)
    @NSManaged public func addToLessons(_ value: Lesson)

    @objc(removeGroupsObject:)
    @NSManaged public func removeFromLessons(_ value: Lesson)

    @objc(addGroups:)
    @NSManaged public func addToLessons(_ values: NSSet)

    @objc(removeGroups:)
    @NSManaged public func removeFromLessons(_ values: NSSet)
}

