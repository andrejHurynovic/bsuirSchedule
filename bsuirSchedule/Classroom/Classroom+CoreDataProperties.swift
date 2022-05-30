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

extension Classroom : Identifiable, Lessonable {
    var educationStart: Date? {
        LessonStorage.groups(lessons: self.lessons).compactMap { $0.educationStart }.sorted().first
    }
    var educationEnd: Date? {
        LessonStorage.groups(lessons: self.lessons).compactMap { $0.educationEnd }.sorted().last
    }
    var examsStart: Date? {
        LessonStorage.groups(lessons: self.lessons).compactMap { $0.examsStart }.sorted().first
    }
    var examsEnd: Date? {
        LessonStorage.groups(lessons: self.lessons).compactMap { $0.examsEnd }.sorted().last
    }
    
    var educationDates: [Date] {
        datesBetween(educationStart, educationEnd)
    }
    var examsDates: [Date] {
        datesBetween(examsStart, examsEnd)
    }
    var educationRange: ClosedRange<Date>? {
        let dates = [educationStart, educationEnd, examsStart, examsEnd].compactMap {$0}.sorted()
        guard dates.isEmpty == false else {
            return nil
        }
        return dates.first!...dates.last!
    }
    
    
    
    func lessonsSections() -> [LessonsSection] {
        var sections: [LessonsSection] = []
        
        let educationDates = datesBetween(educationRange?.lowerBound, educationRange?.upperBound)
        educationDates.forEach({ date in
            var lessons = lessons?.allObjects as! [Lesson]
            lessons = lessons.filter { lesson in
                if let lessonDate = lesson.date  {
                    return date == lessonDate
                } else {
                    return lesson.weekday == date.weekDay().rawValue && lesson.weeks.contains(date.educationWeek) && Array((lesson.groups?.allObjects as! [Group]).map {$0.educationDates}.joined()).contains(date) == true
                }
            }
            if lessons.isEmpty == false {
                sections.append(LessonsSection(date: date, showWeek: true, lessons: lessons))
            }
        })
        return sections
    }
}
