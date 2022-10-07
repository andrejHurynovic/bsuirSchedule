//
//  Employee+CoreDataProperties.swift
//  Employee
//
//  Created by Andrej Hurynovič on 7.09.21.
//
//

import Foundation
import UIKit
import CoreData


extension Employee {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Employee> {
        let request = NSFetchRequest<Employee>(entityName: "Employee")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Employee.lastName, ascending: true)]
        return request
    }
    
    @NSManaged public var id: Int32
    @NSManaged public var urlID: String!
    @NSManaged public var firstName: String!
    @NSManaged public var middleName: String!
    @NSManaged public var lastName: String!
    
    @NSManaged public var rank: String?
    @NSManaged public var degree: String?
    @NSManaged public var departments: [String]!
    @NSManaged public var favourite: Bool
    @NSManaged public var updateDate: Date?
    
    @NSManaged public var educationStart: Date?
    @NSManaged public var educationEnd: Date?
    @NSManaged public var examsStart: Date?
    @NSManaged public var examsEnd: Date?
    
    @NSManaged public var photoLink: String!
    @NSManaged public var photo: Data?
    
    @NSManaged public var lessons: NSSet?
    
}

// MARK: Generated accessors for lessons
extension Employee {
    
    @objc(addLessonsObject:)
    @NSManaged public func addToLessons(_ value: Lesson)
    
    @objc(removeLessonsObject:)
    @NSManaged public func removeFromLessons(_ value: Lesson)
    
    @objc(addLessons:)
    @NSManaged public func addToLessons(_ values: NSSet)
    
    @objc(removeLessons:)
    @NSManaged public func removeFromLessons(_ values: NSSet)
    
}

extension Employee: Identifiable { }
extension Employee: EducationDated { }
extension Employee: LessonsSectioned { }

//MARK: Request
extension Employee {
    static func getEmployees() -> [Employee] {
        let request = self.fetchRequest()
        let employees = try! PersistenceController.shared.container.viewContext.fetch(request)
        
        return employees
    }
    
}

//MARK: Fetch
extension Employee {
    static func fetchAllEmployees() async {
        let data = try! await URLSession.shared.data(from: FetchDataType.employees.rawValue)
        guard let dictionaries = try! JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
            return
        }
        
        let employees = getEmployees()
        
        for dictionary in dictionaries {
            let decoder = JSONDecoder()
            decoder.userInfo[.managedObjectContext] = PersistenceController.shared.container.viewContext
            let data = try! JSONSerialization.data(withJSONObject: dictionary)
            
            if let employee = employees.first (where: { $0.id == dictionary["id"] as! Int32 }) {
                var employeee = employee
                try! decoder.update(&employeee, from: data)
            } else {
                let _ = try! decoder.decode(Employee.self, from: data)
            }
        }
    }
    
}

//MARK: Update
extension Employee {
    func update() async -> Employee? {
        guard let url = URL(string: FetchDataType.employee.rawValue + String(self.urlID)) else {
            return nil
        }
        let (data, _) = try! await URLSession.shared.data(from: url)
        var employee = self
        let decoder = JSONDecoder()
        decoder.userInfo[.managedObjectContext] = PersistenceController.shared.container.viewContext
        try! decoder.update(&employee, from: data)
        return employee
    }
    static func updateEmployees(employees: [Employee]) async {
        try! await withThrowingTaskGroup(of: Employee?.self) { group in
            for employee in employees {
                group.addTask {
                    await employee.update()
                }
            }
            //Await all tasks
            for try await _ in group { }
        }
    }
    
    func updatePhoto() async -> Data? {
        guard let url = URL(string: self.photoLink) else {
            return nil
        }
        let (data, _) = try! await URLSession.shared.data(from: url)
        guard data.count != 0 else {
            return nil
        }
        
        self.photo = data
        return nil
    }
    static func updatePhotos(for employees: [Employee]) async {
        try! await withThrowingTaskGroup(of: Data?.self) { group in
            for employee in employees {
                group.addTask {
                    await employee.updatePhoto()
                }
            }
            //Await all tasks
            for try await _ in group { }
        }
    }
    
}
