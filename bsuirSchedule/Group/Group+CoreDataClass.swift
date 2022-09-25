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
            self.educationStart = DateFormatters.shared.get(.shortDate).date(from: educationStartString)
            self.educationEnd = DateFormatters.shared.get(.shortDate).date(from: try! container.decode(String.self, forKey: .educationEnd))
        }

        if let examsStartString = try? container.decode(String.self, forKey: .examsStart) {
            self.examsStart = DateFormatters.shared.get(.shortDate).date(from: examsStartString)
            self.examsEnd = DateFormatters.shared.get(.shortDate).date(from: try! container.decode(String.self, forKey: .examsEnd))
        }
        
        if var schedules = try? container.decode([String:[Lesson]].self, forKey: .lessons) {
            schedules.keys.forEach { key in
                let weekDay = WeekDay(string: key)
                schedules[key]!.forEachInout { lesson in
                    lesson.weekday = weekDay.rawValue
                }
            }
            self.addToLessons(NSSet(array: Array(schedules.values.joined()) as! [Lesson]))
        }
        
        if let exams = try? container.decode([Lesson].self, forKey: .exams) {
            self.addToLessons(NSSet(array: exams))
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
    
    case educationStart = "startDate"
    case educationEnd = "endDate"
    case examsStart = "startExamsDate"
    case examsEnd = "endExamsDate"
    
    case lessons = "schedules"
    case exams = "exams"
    
    case groupContainer = "studentGroupDto"
}
