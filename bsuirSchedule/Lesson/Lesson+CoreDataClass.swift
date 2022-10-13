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
//        let context = decoder.userInfo[.managedObjectContext] as! NSManagedObjectContext
        let context = PersistenceController.shared.container.viewContext
        self.init(entity: Lesson.entity(), insertInto: context)
        
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
        if let classroomNames = try? container.decode([String].self, forKey: .classroom) {
            
            let classrooms = decoder.userInfo[.classrooms] as! [Classroom]
            
            classroomNames.forEach { classroomName in
                //If the classroom is unknown it is created from the available information
                if let classroom = classrooms.first(where: { $0.originalName == classroomName }) {
                    if self != nil {
                        self.addToClassrooms(classroom)
                    }
                    
                } else {
                    print("\(classroomName) == \(classroomName)")
                    
                    let classroom = try! Classroom(string: classroomName, context: context)
                    self.addToClassrooms(classroom)
                }
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
        if let employeeDictionaries = try? container.decode(Array<Any>.self, forKey: .employees) as? [[String: Any]] {
            let employees = decoder.userInfo[.employees] as! [Employee]
            var lessonsEmployees: [Employee] = []
            
            for dictionary in employeeDictionaries {
                let decoder = JSONDecoder()
                decoder.userInfo[.managedObjectContext] = PersistenceController.shared.container.viewContext
                let data = try! JSONSerialization.data(withJSONObject: dictionary)
                
                if let employee = employees.first (where: { $0.id == Int32(dictionary["id"] as! Int) }) {
                    var mutableEmployee = employee
                    try! decoder.update(&mutableEmployee, from: data)
                    lessonsEmployees.append(mutableEmployee)
                    
                } else {
                    let employee = try! decoder.decode(Employee.self, from: data)
                    lessonsEmployees.append(employee)
                }
            }
            self.employeesIDs = lessonsEmployees.map {$0.id}
            self.addToEmployees(NSSet(array: lessonsEmployees))
            
        }

        //MARK: Groups
        let groupsDictionaries = try! container.decode(Array<Any>.self, forKey: .groups) as! [[String: Any]]
        
        let groups = decoder.userInfo[.groups] as! [Group]
        let nestedDecoder = JSONDecoder()
        nestedDecoder.userInfo[.managedObjectContext] = decoder.userInfo[.managedObjectContext]
        nestedDecoder.userInfo[.specialities] = decoder.userInfo[.specialities]
    
        for dictionary in groupsDictionaries {
            let data = try! JSONSerialization.data(withJSONObject: dictionary)
            
            if let group = groups.first (where: { $0.id == dictionary["name"] as? String }) {
                var mutableGroup = group
                try! nestedDecoder.update(&mutableGroup, from: data)
                self.addToGroups(mutableGroup)
            } else {
                let group = try! nestedDecoder.decode(Group.self, from: data)
                self.addToGroups(group)
            }
        }
    }
    
}

extension Lesson: Decodable {
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
