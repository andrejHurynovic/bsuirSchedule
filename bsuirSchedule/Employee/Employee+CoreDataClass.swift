//
//  Employee+CoreDataClass.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 4.06.21.
//
//

import Foundation
import CoreData
import UIKit.UIImage

@objc(Employee)
public class Employee: NSManagedObject, Decodable {
    
    required public convenience init(from decoder: Decoder) throws {
        let context = PersistenceController.shared.container.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Employee", in: context)
        self.init(entity: entity!, insertInto: context)
        
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
        
//        if let schedules = try? container.decode([Schedule].self, forKey: .lessons) {
//            schedules.forEach { schedule in
//                self.addToLessons(NSSet(array: schedule.lessons))
//            }
//        }
//        if let examSchedules = try? container.decode([Schedule].self, forKey: .exams) {
//            examSchedules.forEach { schedule in
//                self.addToLessons(NSSet(array: schedule.lessons))
//            }
//        }
        
        
        //Структура employee существует при получении ответа на запрос Schedule. Нужна для автоматического слияния при обновлении группы таким образом. Причём это может быть как обновление группы с уже загруженным расписанием, так и без него.
        if let employeeContainer = try? container.nestedContainer(keyedBy: CodingKeys.self, forKey: .employeeContainer) {
            container = employeeContainer
        }
        
        self.id = (try! container.decode(Int32.self, forKey: .id))
        if let urlID = try? container.decode(String.self, forKey: .urlID) {
            self.urlID = urlID
        } else {
            
        }
        self.firstName = try! container.decode(String.self, forKey: .firstName)
        self.middleName = try? container.decode(String.self, forKey: .middleName)
        self.lastName = try! container.decode(String.self, forKey: .lastName)
        
        
        self.rank = try? container.decode(String.self, forKey: .rank)
        self.degree = try? container.decode(String.self, forKey: .degree)
        if var departments = try? container.decode([String].self, forKey: .departments) {
            departments.forEachInout { department in
                if let range = department.range(of: "каф.") {
                    department.removeSubrange(range)
                }
                department = department.trimmingCharacters(in: .whitespaces)
            }
            self.departments = departments
        }
        self.favorite = false
        
        self.photoLink = try? container.decode(String.self, forKey: .photoLink)
        
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case urlID = "urlId"
        case firstName
        case middleName
        case lastName
        
        case educationStart = "startDate"
        case educationEnd = "endDate"
        case examsStart = "startExamsDate"
        case examsEnd = "endExamsDate"
        
        case departments = "academicDepartment"
        case rank
        case degree
        
        case photoLink
        
        case lessons = "schedules"
        case exams = "examSchedules"
        
        case employeeContainer = "employeeDto"
    }
}

