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
    @NSManaged public var urlID: String?
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
    
    @NSManaged public var photoLink: String?
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
    static func getAll(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) -> [Employee] {
        try! context.fetch(self.fetchRequest())
    }
}

//MARK: Fetch
extension Employee {
    static func fetchAll() async {
        let data = try! await URLSession.shared.data(from: FetchDataType.employees.rawValue)
        let startTime = CFAbsoluteTimeGetCurrent()
        guard let dictionaries = try! JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
            Log.error("Can't create employees dictionaries.")
            return
        }
        
        let backgroundContext = PersistenceController.shared.container.newBackgroundContext()
        backgroundContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        let decoder = JSONDecoder()
        decoder.userInfo[.managedObjectContext] = backgroundContext
        decoder.userInfo[.groupEmbeddedContainer] = true
        
        var employees = getAll(context: backgroundContext)
        
        for dictionary in dictionaries {
            let data = try! JSONSerialization.data(withJSONObject: dictionary)
            
            if var employee = employees.first (where: { $0.id == dictionary["id"] as? Int32 }) {
                try! decoder.update(&employee, from: data)
            } else {
                let employee = try! decoder.decode(Employee.self, from: data)
                employees.append(employee)
            }
        }
        
        await backgroundContext.perform(schedule: .immediate, {
            try! backgroundContext.save()
            Log.info("\(String(employees.count)) Employees fetched, time: \((CFAbsoluteTimeGetCurrent() - startTime).roundTo(places: 3)) seconds.\n")
        })
        
    }
    
}

//MARK: Update
extension Employee {
    func update(decoder: JSONDecoder? = nil) async -> Employee? {
        guard let urlID = self.urlID,
              let url = URL(string: FetchDataType.employee.rawValue + urlID),
              let (data, _) = try? await URLSession.shared.data(from: url) else {
            Log.error("No data for employee (\(String(self.id)))")
            return nil
        }
        
        guard data.count != 0 else {
            Log.warning("Empty data while updating employee \(self.urlID ?? "no urlID") (\(String(self.id)))")
            return nil
        }
        
        //
        let backgroundContext = PersistenceController.shared.container.newBackgroundContext()
        backgroundContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        let decoder = JSONDecoder()
        decoder.userInfo[.managedObjectContext] = backgroundContext
        decoder.userInfo[.groupEmbeddedContainer] = true
        
        var backgroundEmployee = backgroundContext.object(with: self.objectID) as! Employee
        let previousPhotoLink = backgroundEmployee.photoLink
        
        try! decoder.update(&backgroundEmployee, from: data)
        
        await backgroundContext.perform(schedule: .immediate, {
            try! backgroundContext.save()
        })
        
        if backgroundEmployee.photoLink != previousPhotoLink || backgroundEmployee.photoLink != nil, backgroundEmployee.photo == nil {
            backgroundEmployee.photo = await fetchPhoto()
        }
        
        await backgroundContext.perform(schedule: .immediate, {
            try! backgroundContext.save()
        })
        
        return self
    }
    
    static func updateEmployees(employees: [Employee]) async {
        let startTime = CFAbsoluteTimeGetCurrent()
        try! await withThrowingTaskGroup(of: Employee?.self) { taskGroup in
            for employee in employees {
                taskGroup.addTask {
                    await employee.update()
                }
            }
            try await taskGroup.waitForAll()
        }
        Log.info("Employees updated in time: \((CFAbsoluteTimeGetCurrent() - startTime).roundTo(places: 3)) seconds")
    }
    
}

extension Employee {
    
    func fetchPhoto() async -> Data? {
        guard let photoLink = self.photoLink,
              let url = URL(string: photoLink) else {
            Log.error("No data for employee photo (\(String(self.id)))")
            return nil
        }
        
        let (data, _) = try! await URLSession.shared.data(from: url)
        guard data.count != 0 else {
            Log.warning("Empty data while updating employee photo \(self.urlID ?? "no urlID") (\(String(self.id)))")
            return nil
        }
        
        Log.info("Employee \(self.urlID ?? "no urlID") (\(String(self.id))) photo has been updated.")
        return data
    }
    
}

//MARK: Accessors
extension Employee {
    var groups: [Group] {
        guard let groups = self.lessons?.compactMap({ ($0 as! Lesson).groups?.allObjects as? [Group]}) else {
            return []
        }
        
        return Set(groups.map({ $0 }).joined()).sorted {$0.id! < $1.id!}
    }
}
