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
public class Lesson: NSManagedObject, Decodable {
    
    required convenience public init(from decoder: Decoder) throws {
        let context = decoder.userInfo[.managedObjectContext] as! NSManagedObjectContext
        let entity = Lesson.entity()
        self.init(entity: entity, insertInto: context)
        
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        
        self.subject = try? container.decode(String.self, forKey: .subject)
        //Abbreviation cannot be optional, because it used as constraint
        self.abbreviation = ((try? container.decode(String.self, forKey: .abbreviation)) ?? "")
        
        self.note = try? container.decode(String.self, forKey: .note)
        self.subgroup = Int16(try! container.decode(Int.self, forKey: .subgroup))
        
        switch (try? container.decode(String.self, forKey: .lessonTypeValue)) {
        case "ЛК":
            self.lessonType = .lecture
        case "УЛк":
            self.lessonType = .remoteLecture
        case "ПЗ":
            self.lessonType = .practice
        case "УПз":
            self.lessonType = .remotePractice
        case "ЛР":
            self.lessonType = .laboratory
        case "УЛР":
            self.lessonType = .remoteLaboratory
        case "Экзамен":
            self.lessonType = .exam
        case "Консультация":
            self.lessonType = .consultation
        case "Кандидатский зачет":
            self.lessonType = .candidateText
        default:
            self.lessonType = .none
            break
        }
        
        //MARK: Classrooms
        if let classrooms = try? container.decode([String].self, forKey: .classroom) {
            classrooms.forEach { classroomName in
                //If the classroom is unknown it is created from the available information
//                if let classroom = ClassroomStorage.shared.classroom(name: classroomName) {
//                    self.addToClassrooms(classroom)
//                } else {
                let classroom = Classroom(string: classroomName, context: context)
                    print("\(classroomName) == \(classroom.formattedName(showBuilding: true))")
                    self.addToClassrooms(classroom)
//                }
            }
        }
        
        //MARK: Date and time
        if let date = try? container.decode(String.self, forKey: .date) {
            self.dateString = date
        } else {
            self.dateString = ""
        }
        
        if let startLessonDateString = try? container.decode(String.self, forKey: .startLessonDate) {
            self.startLessonDate = DateFormatters.shared.shortDate.date(from: startLessonDateString)
            self.endLessonDate
            = DateFormatters.shared.shortDate.date(from: try! container.decode(String.self, forKey: .endLessonDate))
        }
        
        self.timeStart = try! container.decode(String.self, forKey: .timeStart)
        self.timeEnd = try! container.decode(String.self, forKey: .timeEnd)
        
        //MARK: Weeks
        // An array of weeks can take values [0, 1, 2, 3 ,4], but it is more convenient for us to count the weeks from zero, and in the API 0 means that there is an occupation for all weeks, so we subtract one from all the values of the array.
        //[1, 2 ,4] -> [0, 1, 3]
        if let weeks = try? container.decode([Int].self, forKey: .weeks) {
            self.weeks = weeks.map{ $0 - 1 }
            if self.weeks.contains(-1) {
                self.weeks.removeFirst()
            }
        }
        
        //MARK: Announcement
        if try! container.decode(Bool.self, forKey: .announcement) == true {
            self.abbreviation = "Объявление"
            
            //Announcement can be repeated every certain day of the week, the boundaries of which are defined by startLessonDate and endLessonDate
            self.weeks = [0, 1, 2, 3]
            //Start and end time in announcementStart and announcementEnd fields can be different then time in timeStart and timeEnd
            self.timeStart = try! container.decode(String.self, forKey: .announcementStart)
            self.timeEnd = try! container.decode(String.self, forKey: .announcementEnd)
            
            let weekday = self.startLessonDate!.weekDay()
            self.weekday = weekday.rawValue
        }
        
        //MARK: Employees
        if let employees = try? container.decode([Employee].self, forKey: .employees) {
            self.employeesIDs = employees.map {$0.id}
            self.addToEmployees(NSSet(array: employees))
        }

        //MARK: Groups
        let groups = try! container.decode([Group].self, forKey: .groups)
        self.addToGroups(NSSet(array: groups))
    }
    
    
    
    private enum CodingKeys: String, CodingKey {
        case subject = "subjectFullName"
        case abbreviation = "subject"
        case lessonTypeValue = "lessonTypeAbbrev"
        case announcement = "announcement"
        case classroom = "auditories"
        case note = "note"
        
        case groups = "studentGroups"
        case subgroup = "numSubgroup"
        
        case weeks = "weekNumber"
        case timeStart = "startLessonTime"
        case timeEnd = "endLessonTime"
        case announcementStart = "announcementStart"
        case announcementEnd = "announcementEnd"
        case date = "dateLesson"
        case startLessonDate = "startLessonDate"
        case endLessonDate = "endLessonDate"
        
        case employees = "employees"
    }
}
