//
//  Auditorium.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 25.09.21.
//

import CoreData

extension Auditorium {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Auditorium> {
        let request = NSFetchRequest<Auditorium>(entityName: "Auditorium")
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Auditorium.outsideUniversity, ascending: false),
            NSSortDescriptor(keyPath: \Auditorium.building, ascending: true),
            NSSortDescriptor(keyPath: \Auditorium.formattedName, ascending: true)]
        return request
    }
    
    @NSManaged public var floor: Int16
    @NSManaged public var name: String
    @NSManaged public var formattedName: String
    ///Used for constraints and effective search when decoding Lessons.
    @NSManaged public var note: String?
    @NSManaged public var favorite: Bool
    
    @NSManaged public var outsideUniversity: Bool
    @NSManaged public var building: Int16
    @NSManaged public var capacity: Int16
    
    @NSManaged public var type: AuditoriumType?
    @NSManaged public var department: Department?
    
    @NSManaged public var lessons: NSSet?
}

//MARK: - Generated accessors
extension Auditorium {
    @objc(addLessonsObject:)
    @NSManaged public func addToLessons(_ value: Lesson)
    @objc(removeLessonsObject:)
    @NSManaged public func removeFromLessons(_ value: Lesson)
    @objc(addLessons:)
    @NSManaged public func addToLessons(_ values: NSSet)
    @objc(removeLessons:)
    @NSManaged public func removeFromLessons(_ values: NSSet)
    @objc(addCompoundSchedulesObject:)
    @NSManaged public func addToCompoundSchedules(_ value: CompoundSchedule)
    @objc(removeCompoundSchedulesObject:)
    @NSManaged public func removeFromCompoundSchedules(_ value: CompoundSchedule)
    @objc(addCompoundSchedules:)
    @NSManaged public func addToCompoundSchedules(_ values: NSSet)
    @objc(removeCompoundSchedules:)
    @NSManaged public func removeFromCompoundSchedules(_ values: NSSet)
}
