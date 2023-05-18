//
//  Lesson+CoreDataClass.swift
//  Lesson
//
//  Created by Andrej Hurynovič on 6.09.21.
//
//

import CoreData
import SwiftUI

@objc(Lesson)
public class Lesson: NSManagedObject {
    
    required convenience public init(from decoder: Decoder) throws {
        let context = decoder.userInfo[.managedObjectContext] as! NSManagedObjectContext
        self.init(entity: Lesson.entity(), insertInto: context)
        
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        
        decodeLesson(container, context)
        decodeDate(container)
        decodeAnnouncement(container)
        decodeGroups(container, decoder, context)
        decodeEmployees(container, decoder, context)
        decodeAuditories(container, decoder, context)
    }
    
    private func decodeLesson(_ container: KeyedDecodingContainer<Lesson.CodingKeys>, _ context: NSManagedObjectContext) {
        self.subject = try? container.decode(String.self, forKey: .subject)
        //Abbreviation cannot be optional, because it is used as constraint
        self.abbreviation = (try? container.decode(String.self, forKey: .abbreviation)) ?? ""
        
        self.note = try? container.decode(String.self, forKey: .note)
        self.subgroup = Int16(try! container.decode(Int.self, forKey: .subgroup))
        
        if let lessonTypeID = try? container.decode(String.self, forKey: .lessonTypeValue) {
            self.type = LessonType(id: lessonTypeID, context: context)
        }
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
            self.startLessonDate = DateFormatters.short.date(from: startLessonDateString)
            self.endLessonDate = DateFormatters.short.date(from: try! container.decode(String.self, forKey: .endLessonDate))
            
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
            self.weekday = date.weekday
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
            //Depreciated?
            if let announcementStart = try? container.decode(String.self, forKey: .announcementStart) {
                self.timeStart = announcementStart
            }
            if let announcementEnd = try? container.decode(String.self, forKey: .announcementEnd) {
                self.timeEnd = announcementEnd
            }
        }
        
    }
    
    private func decodeAuditories(_ container: KeyedDecodingContainer<Lesson.CodingKeys>, _ decoder: Decoder, _ context: NSManagedObjectContext) {
        if let auditoriumNames = try? container.decode([String].self, forKey: .auditorium) {
            let auditories = auditoriumNames.map { (try! Auditorium(from: $0, in: context)) }
            self.addToAuditories(NSSet(array: auditories))
            self.auditoriesNames = auditories.map { "\($0.floor)\(String(describing: $0.name))-\($0.building)" }.sorted()
        } else {
            self.auditoriesNames = []
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
        case auditorium = "auditories"
    }
}
