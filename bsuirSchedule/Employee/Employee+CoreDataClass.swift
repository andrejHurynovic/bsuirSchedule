//
//  Employee+CoreDataClass.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 4.06.21.
//
//

import Foundation
import CoreData
//import UIKit.UIImage

@objc(Employee)
public class Employee: NSManagedObject {
    
    required public convenience init(from decoder: Decoder) throws {
        let context = decoder.userInfo[.managedObjectContext] as! NSManagedObjectContext
        self.init(entity: Employee.entity(), insertInto: context)
        try! self.update(from: decoder)
        Log.info("Employee \(self.urlID ?? "no urlID") (\(String(self.id))) has been created.")
    }
    
}

//MARK: Update
extension Employee: DecoderUpdatable {
    func update(from decoder: Decoder) throws {
        let startTime = CFAbsoluteTimeGetCurrent()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        decodeEmployee(decoder)
        decodeEducationDates(decoder)
        
        if let lessons = try? container.decode([String:[Lesson]].self, forKey: .lessons) {
            let lessons = Set(lessons.map{ $1 }.joined())
            for lesson in lessons {
                lesson.employeesIDs = [self.id]
                lesson.addToEmployees(self)
            }
        }
        if let exams = try? container.decode([Lesson].self, forKey: .exams) {
            for exam in exams {
                exam.employeesIDs = [self.id]
                exam.addToEmployees(self)
            }
        }
        
        Log.info("Employee \(self.urlID ?? "no urlID") (\(String(self.id))) has been updated, time: \((CFAbsoluteTimeGetCurrent() - startTime).roundTo(places: 3)) seconds")
    }
    
    private func decodeEmployee(_ decoder: Decoder) {
        //The employee information structure nested container exists only when receiving a response to the Schedule (Group) request. This fields is also contained when fetching all groups, but located in root.
        let container = (try? decoder.container(keyedBy: CodingKeys.self)
            .nestedContainer(keyedBy: CodingKeys.self, forKey: .employeeNestedContainer))
        ?? (try! decoder.container(keyedBy: CodingKeys.self))
        
        self.id = (try! container.decode(Int32.self, forKey: .id))
        if let urlID = try? container.decode(String.self, forKey: .urlID) {
            self.urlID = urlID
        } else {
            self.urlID = ""
        }
        self.firstName = try! container.decode(String.self, forKey: .firstName)
        self.middleName = try? container.decode(String.self, forKey: .middleName)
        self.lastName = try! container.decode(String.self, forKey: .lastName)
        
        self.rank = try? container.decode(String.self, forKey: .rank)
        self.degree = try? container.decode(String.self, forKey: .degree)
        self.photoLink = try? container.decode(String.self, forKey: .photoLink)
        
        if var departments = try? container.decode([String].self, forKey: .departments) {
            departments.forEachInout { department in
                if let range = department.range(of: "Каф.") {
                    department.removeSubrange(range)
                }
                department = department.trimmingCharacters(in: .whitespaces)
            }
            self.departments = departments
        }
        
    }
}

extension Employee: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case urlID = "urlId"
        case firstName
        case middleName
        case lastName
        
        case departments = "academicDepartment"
        case rank
        case degree
        
        case photoLink
        
        case lessons = "schedules"
        case exams = "exams"
        
        case employeeNestedContainer = "employeeDto"
    }
}
