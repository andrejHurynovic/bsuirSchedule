//
//  Group+CoreDataProperties.swift
//  Group
//
//  Created by Andrej Hurynovič on 6.09.21.
//
//

import Foundation
import CoreData

extension Group {
    
    @NSManaged public var id: String!
    @NSManaged public var course: Int16
    @NSManaged public var favorite: Bool
    @NSManaged public var updateDate: Date?
    
    @NSManaged public var speciality: Speciality!
    
    @NSManaged public var educationStart: Date?
    @NSManaged public var educationEnd: Date?
    @NSManaged public var examsStart: Date?
    @NSManaged public var examsEnd: Date?
    
    @NSManaged public var lessons: NSSet?
    
}

// MARK: Generated accessors for lessons
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

extension Group: Identifiable, Lessonable {
    
    //Lessonable
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
    
    func educationSections() -> [LessonsSection]? {
        var sections: [LessonsSection] = []
        
        let educationDates = educationDates
        educationDates.forEach({ date in
            var lessons = lessons?.allObjects as! [Lesson]
            lessons = lessons.filter { lesson in
                lesson.weekday == date.weekDay().rawValue && lesson.weeks.contains(date.educationWeek)
            }
//            lessons = lessons.filter { lesson in
//                lesson.dates.contains { lessonDate in
//                    Calendar.current.isDate(lessonDate, inSameDayAs: date)
//                }
//            }
            if lessons.isEmpty == false {
                sections.append(LessonsSection(date: date, showWeek: true, lessons: lessons))
            }
        })
        return sections
    }
    
    func examsSections() -> [LessonsSection]? {
        var sections: [LessonsSection] = []
        
        let examsDates = examsDates
        examsDates.forEach({ date in
            var lessons = lessons?.allObjects as! [Lesson]
            lessons = lessons.filter { lesson in
                guard let lessonDate = lesson.date else {
                    return false
                }
                return date == lessonDate
            }
            if lessons.isEmpty == false {
                sections.append(LessonsSection(date: date, showWeek: false, lessons: lessons))
            }
        })
        return sections
    }
    
    func lessonsSections() -> [LessonsSection] {
        var lessonsSection: [LessonsSection] = []
        lessonsSection.append(contentsOf: educationSections() ?? [])
        lessonsSection.append(contentsOf: examsSections() ?? [])
        return lessonsSection
    }
}
