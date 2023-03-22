//
//  Lesson+CoreDataClass.swift
//  Lesson
//
//  Created by Andrej Hurynovič on 6.09.21.
//
//

import Foundation
import CoreData
import SwiftUI

@objc(Lesson)
public class Lesson: NSManagedObject {
    
    required convenience public init(from decoder: Decoder) throws {
        let context = decoder.userInfo[.managedObjectContext] as! NSManagedObjectContext
        self.init(entity: Lesson.entity(), insertInto: context)
        
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        
        decodeLesson(container)
        decodeDate(container)
        decodeAnnouncement(container)
        decodeEmployees(container, decoder, context)
        decodeGroups(container, decoder, context)
        decodeClassrooms(container, decoder, context)
    }
    
    private func decodeLesson(_ container: KeyedDecodingContainer<Lesson.CodingKeys>) {
        self.subject = try? container.decode(String.self, forKey: .subject)
        //Abbreviation cannot be optional, because it is used as constraint
        self.abbreviation = (try? container.decode(String.self, forKey: .abbreviation)) ?? ""
        
        self.note = try? container.decode(String.self, forKey: .note)
        self.subgroup = Int16(try! container.decode(Int.self, forKey: .subgroup))
        
        lessonType = LessonType(from: try? container.decode(String.self, forKey: .lessonTypeValue))
    }
    
    private func decodeDate(_ container: KeyedDecodingContainer<Lesson.CodingKeys>) {
        //DateString is a constraint, so it cannot be optional.
        if let date = try? container.decode(String.self, forKey: .date) {
            self.dateString = date
        } else {
            self.dateString = ""
        }
        
        if let startLessonDateString = try? container.decode(String.self, forKey: .startLessonDate) {
            self.startLessonDateString = startLessonDateString
            self.startLessonDate = DateFormatters.shared.shortDate.date(from: startLessonDateString)
            self.endLessonDate = DateFormatters.shared.shortDate.date(from: try! container.decode(String.self, forKey: .endLessonDate))
            
            if let startLessonDate = startLessonDate,
               let endLessonDate = endLessonDate,
               startLessonDate > endLessonDate {
                self.endLessonDate = startLessonDate
                self.startLessonDate = endLessonDate
            }
        } else {
            self.startLessonDateString = ""
        }
        
        self.timeStart = try! container.decode(String.self, forKey: .timeStart)
        self.timeEnd = try! container.decode(String.self, forKey: .timeEnd)
        
        if let date = (self.date ?? self.startLessonDate) {
            self.weekday = date.weekDay().rawValue
        }
        
        // An array of weeks can take values [0, 1, 2, 3 ,4], but it is more convenient to count the weeks from zero, and in the API 0 means that there is an occupation for all weeks, so we subtract one from all the values of the array.
        //[1, 2 ,4] -> [0, 1, 3]
        if let weeks = try? container.decode([Int].self, forKey: .weeks) {
            self.weeks = weeks.map{ $0 - 1 }
            //Пояснить это позже
            if self.weeks.contains(-1) {
                self.weeks.removeFirst()
            }
        } else {
            weeks = []
        }
        
    }
    
    private func decodeAnnouncement(_ container: KeyedDecodingContainer<Lesson.CodingKeys>) {
        //Перепроверить
        if try! container.decode(Bool.self, forKey: .announcement) == true {
            //Announcement can be repeated every certain day of the week, the boundaries of which are defined by startLessonDate and endLessonDate.
            self.weeks = [0, 1, 2, 3]
            //Start and end time in announcementStart and announcementEnd fields can be different then time in timeStart and timeEnd.
            self.timeStart = try! container.decode(String.self, forKey: .announcementStart)
            self.timeEnd = try! container.decode(String.self, forKey: .announcementEnd)
        }
        
    }
    
    private func decodeClassrooms(_ container: KeyedDecodingContainer<Lesson.CodingKeys>, _ decoder: Decoder, _ context: NSManagedObjectContext) {
        if let classroomNames = try? container.decode([String].self, forKey: .classroom) {
            let classrooms = classroomNames.map { (try! Classroom(from: $0, in: context)) }
            self.addToClassrooms(NSSet(array: classrooms))
            self.classroomsNames = classrooms.map { $0.originalName }.sorted()
        } else {
            self.classroomsNames = []
        }
        
    }
    
    private func decodeEmployees(_ container: KeyedDecodingContainer<Lesson.CodingKeys>, _ decoder: Decoder, _ context: NSManagedObjectContext) {
        if let employees = try? container.decode([Employee].self, forKey: .employees) {
            self.addToEmployees(NSSet(array: employees))
            self.employeesIDs = employees.map { $0.id }.sorted()
        } else {
            self.employeesIDs = []
        }
    }
    
    private func decodeGroups(_ container: KeyedDecodingContainer<Lesson.CodingKeys>, _ decoder: Decoder, _ context: NSManagedObjectContext) {
        if let groups = try? container.decode([Group].self, forKey: .groups) {
            self.addToGroups(NSSet(array: groups))
        }
    }
    
}

extension Lesson: Decodable {
    private enum CodingKeys: String, CodingKey {
        case subject = "subjectFullName"
        case abbreviation = "subject"
        case lessonTypeValue = "lessonTypeAbbrev"
        case announcement = "announcement"
        case note = "note"
        
        case date = "dateLesson"
        case weeks = "weekNumber"
        case startLessonDate = "startLessonDate"
        case endLessonDate = "endLessonDate"
        case announcementStart = "announcementStart"
        case announcementEnd = "announcementEnd"
        case timeStart = "startLessonTime"
        case timeEnd = "endLessonTime"
        
        case groups = "studentGroups"
        case subgroup = "numSubgroup"
        case employees = "employees"
        case classroom = "auditories"
    }
}
