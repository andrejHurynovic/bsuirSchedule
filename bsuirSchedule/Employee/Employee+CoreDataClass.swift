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
public class Employee: NSManagedObject, Decodable, Lessonable {
    
    required public convenience init(from decoder: Decoder) throws {
        let context = PersistenceController.shared.container.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Employee", in: context)
        self.init(entity: entity!, insertInto: context)
        
        var container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let schedules = try? container.decode([Schedule].self, forKey: .lessons) {
            schedules.map { $0.lessons }.forEach { lessons in
                self.addToLessons(NSSet(array: lessons))
            }
        }
        
        if let examSchedules = try? container.decode([Schedule].self, forKey: .exams) {
            examSchedules.map { $0.lessons }.forEach { lessons in
                self.addToLessons(NSSet(array: lessons!))
            }
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
        
        if let groupContainer = try? container.nestedContainer(keyedBy: CodingKeys.self, forKey: .employeeContainer) {
            container = groupContainer
        }
        
        self.id = (try! container.decode(Int32.self, forKey: .id))
        self.urlID = try! container.decode(String.self, forKey: .urlID)
        self.firstName = try! container.decode(String.self, forKey: .firstName)
        self.middleName = try! container.decode(String.self, forKey: .middleName)
        self.lastName = try! container.decode(String.self, forKey: .lastName)
        self.lastUpdateDate = Date()
        
        self.rank = try? container.decode(String.self, forKey: .rank)
        self.degree = try? container.decode(String.self, forKey: .degree)
        if var departments = try? container.decode([String].self, forKey: .departments) {
            departments.forEach { department in
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
        
        case educationStart = "dateStart"
        case educationEnd = "dateEnd"
        case examsStart = "sessionStart"
        case examsEnd = "sessionEnd"
        
        case departments = "academicDepartment"
        case rank
        case degree
        
        case photoLink
        
        case lessons = "schedules"
        case exams = "examSchedules"
        
        case employeeContainer = "employee"
    }
}

