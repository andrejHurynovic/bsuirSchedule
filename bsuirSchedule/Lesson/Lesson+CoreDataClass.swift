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
        let context = PersistenceController.shared.container.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Lesson", in: context)
        self.init(entity: entity!, insertInto: context)
        
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        
        self.subject = try? container.decode(String.self, forKey: .subject)
        //Abbreviation cannot be optional, because it used as constraint
        self.abbreviation = ((try? container.decode(String.self, forKey: .abbreviation)) ?? "")
        
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
            if let type = try? container.decode(String.self, forKey: .lessonTypeValue) {
                print(type)
            }
            self.lessonType = .none
            break
        }
        
        if let classrooms = try? container.decode([String].self, forKey: .classroom) {
            classrooms.forEach { classroomName in
                if let classroom = ClassroomStorage.shared.classroom(name: classroomName) {
                    self.addToClassrooms(classroom)
                } else {
#warning("Добавить какой-то иной вывод ошибки")
                    print(classroomName)
                }
            }
        }
        
        self.note = try? container.decode(String.self, forKey: .note)
        
        //        self.addToGroups(NSSet(array: GroupStorage.shared.groups(ids: try! container.decode([String].self, forKey: .groups))))
        self.subgroup = Int16(try! container.decode(Int.self, forKey: .subgroup))
        
        self.timeStart = try! container.decode(String.self, forKey: .timeStart)
        self.timeEnd = try! container.decode(String.self, forKey: .timeEnd)
        
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
        
        //Массив недель может быть [0, 1, 2, 3 ,4], но нам удобнее считать с нуля, так как 0 тут значит, что занятие есть на всех неделях, поэтому отнимаем единицу у всех значений массива.
        
        if let weeks = try? container.decode([Int].self, forKey: .weeks) {
            self.weeks = weeks.map{ $0 - 1 }
            if self.weeks.contains(-1) {
                self.weeks.removeFirst()
            }
        }
        
        let employees: [[String: Any]] = try container.decode(Array<Any>.self, forKey: .employee) as! [[String: Any]]
        
        self.employeesIDs = employees.map { $0["id"] as! Int }
        
        employeesIDs?.forEachInout(body: { employeeID in
            if let employee = EmployeeStorage.shared.values.value.first(where: { $0.id == employeeID }) {
                self.addToEmployees(employee)
            } else {
                print(employeeID)
            }
        })
        
        //MARK: Announcement
        //Announcement are
        if try! container.decode(Bool.self, forKey: .announcement) == true {
            self.abbreviation = "Объявление"
            
            self.weeks = [0, 1, 2, 3]
            self.timeStart = try! container.decode(String.self, forKey: .announcementStart)
            self.timeEnd = try! container.decode(String.self, forKey: .announcementEnd)
            
            let weekday = self.startLessonDate!.weekDay()
            self.weekday = weekday.rawValue
        }
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
        
        case employee = "employees"
    }
}



extension Lesson {
    func getLessonTypeAbbreviation() -> String {
        switch self.lessonType {
        case .none:
            return "Без типа"
        case .lecture:
            return "ЛК"
        case .remoteLecture:
            return "УЛК"
        case .practice:
            return "ПЗ"
        case .remotePractice:
            return "УПЗ"
        case .laboratory:
            return "ЛР"
        case .remoteLaboratory:
            return "УЛР"
        case .consultation:
            return "Конс"
        case .exam:
            return "Экз"
        case .candidateText:
            return "КЗ"
        }
    }
}
