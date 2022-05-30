//
//  Group+CoreDataClass.swift
//  Group
//
//  Created by Andrej Hurynovič on 6.09.21.
//
//

import Foundation
import CoreData

@objc(Group)
public class Group: NSManagedObject, Decodable {
    
    required public convenience init(from decoder: Decoder) throws {
        let context = PersistenceController.shared.container.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Group", in: context)!
        self.init(entity: entity, insertInto: context)
        
        var container = try decoder.container(keyedBy: CodingKeys.self)
        
        //Если существует educationStart или examsStart, всегда существуют соответствующие educationEnd и examsEnd.
        if let educationStartString = try? container.decode(String.self, forKey: .educationStart) {
            self.educationStart = DateFormatters.shared.dateFormatterddMMyyyy.date(from: educationStartString)
            self.educationEnd = DateFormatters.shared.dateFormatterddMMyyyy.date(from: try! container.decode(String.self, forKey: .educationEnd))
        }
        //Более не используется, так как API больше не предоставляет даты начала и окончания сессии
//        if let examsStartString = try? container.decode(String.self, forKey: .examsStart) {
//            self.examsStart = DateFormatters.shared.dateFormatterddMMyyyy.date(from: examsStartString)
//            self.examsEnd = DateFormatters.shared.dateFormatterddMMyyyy.date(from: try! container.decode(String.self, forKey: .examsEnd))
//        }
        
        if let schedules = try? container.decode([Schedule].self, forKey: .lessons) {
            schedules.forEach { schedule in
//                //Назначение корректных дат и времени всем занятиям.
//                schedule.lessons.forEachInout { lesson in
//                    lesson.dates = educationDates.educationDates(weeks: lesson.weeks, weekDay: schedule.weekDay!, time: lesson.dates.first!)
//                }
                self.addToLessons(NSSet(array: schedule.lessons))
            }
        }
        if let examSchedules = try? container.decode([Schedule].self, forKey: .exams) {
            var lessons: [Lesson] = []
            examSchedules.forEach { schedule in
                lessons.append(contentsOf: schedule.lessons)
            }
            //Так как в API больше нет дат начала и конца сессии для сутдентов, приходится получать их вручную
            let examsDates = Array(lessons.map {$0.date!}).sorted()
            if let examsStart = examsDates.first {
                self.examsStart = examsStart.withTime(DateFormatters.shared.dateFormatterHHmm.date(from: "00:00")!)
            }
            if let examsEnd = examsDates.last {
                self.examsEnd = examsEnd.withTime(DateFormatters.shared.dateFormatterHHmm.date(from: "00:00")!)
            }
            self.addToLessons(NSSet(array: lessons))
        }
        
        //Структура studentGroup существует при получении ответа на запрос Schedule. Нужна для автоматического слияния при обновлении группы таким образом. Причём это может быть как обновление группы с уже загруженным расписанием, так и без него.
        if let groupInformation = try? container.nestedContainer(keyedBy: CodingKeys.self, forKey: .groupContainer) {
            container = groupInformation
        }
        if let id = try? container.decode(String.self, forKey: .id) {
            self.id = id
            
            let specialityID = try! container.decode(Int16.self, forKey: .specialityID)
            self.speciality = SpecialityStorage.shared.values.value.first(where: {$0.id == specialityID})
        }
        
        if let course = try? container.decode(Int16.self, forKey: .course) {
            self.course = course
        }
    }
}



private enum CodingKeys: String, CodingKey {
    case id = "name"
    case course
    
    case specialityID = "specialityDepartmentEducationFormId"
    
    case educationStart = "dateStart"
    case educationEnd = "dateEnd"
    case examsStart = "sessionStart"
    case examsEnd = "sessionEnd"
    
    case lessons = "schedules"
    case exams = "examSchedules"
    
    case groupContainer = "studentGroup"
}
