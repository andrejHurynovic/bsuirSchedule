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
        let entity = NSEntityDescription.entity(forEntityName: "Group", in: context)
        self.init(entity: entity!, insertInto: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let id = try? container.decode(String.self, forKey: .id) {
            self.id = id
            
            let specialityID = try! container.decode(Int16.self, forKey: .specialityID)
            self.speciality = SpecialityStorage.shared.values.value.first(where: {$0.id == specialityID})
            if self.speciality == nil {
                
            }
        }
        
        if let course = try? container.decode(Int16.self, forKey: .course) {
            self.course = course
        } else {
            self.course = -1
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        if let educationStartString = try? container.decode(String.self, forKey: .educationStart) {
            self.educationStart = dateFormatter.date(from: educationStartString)
            self.educationEnd = dateFormatter.date(from: try! container.decode(String.self, forKey: .educationEnd))
        }
        if let examsStartString = try? container.decode(String.self, forKey: .examsStart) {
            self.examsStart = dateFormatter.date(from: examsStartString)
            self.examsEnd = dateFormatter.date(from: try! container.decode(String.self, forKey: .examsEnd))
        }
        
        if let schedules = try? container.decode([Schedule].self, forKey: .lessons) {
            schedules.forEach { schedule in
                switch schedule.weekDay {
                case .Monday:
                    schedule.lessons.forEach { lesson in
                        lesson.weekDay = 0
                    }
                case .Tuesday:
                    schedule.lessons.forEach { lesson in
                        lesson.weekDay = 1
                    }
                case .Wednesday:
                    schedule.lessons.forEach { lesson in
                        lesson.weekDay = 2
                    }
                case .Thursday:
                    schedule.lessons.forEach { lesson in
                        lesson.weekDay = 3
                    }
                case .Friday:
                    schedule.lessons.forEach { lesson in
                        lesson.weekDay = 4
                    }
                case .Saturday:
                    schedule.lessons.forEach { lesson in
                        lesson.weekDay = 5
                    }
                case .Sunday:
                    schedule.lessons.forEach { lesson in
                        lesson.weekDay = 6
                    }
                    
                    
                case .none:
                    break
                }
                                
                self.addToLessons(NSSet(array: schedule.lessons))
            }
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
    
    case studentGroupContainer = "studentGroup"
}
