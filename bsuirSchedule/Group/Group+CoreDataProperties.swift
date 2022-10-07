//
//  Group+CoreDataProperties.swift
//  Group
//
//  Created by Andrej Hurynovič on 6.09.21.
//
//

import Foundation
import CoreData

extension Group {
    
    @NSManaged public var id: String!
    @NSManaged public var numberOfStudents: Int16
    @NSManaged public var course: Int16
    @NSManaged public var favourite: Bool
    @NSManaged public var updateDate: Date?
    
    @NSManaged public var speciality: Speciality!
    
    @NSManaged public var educationStart: Date?
    @NSManaged public var educationEnd: Date?
    @NSManaged public var examsStart: Date?
    @NSManaged public var examsEnd: Date?
    
    @NSManaged public var lessons: NSSet?
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Group> {
        let request = NSFetchRequest<Group>(entityName: "Group")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Group.id, ascending: true)]
        return request
    }
}

//MARK: Generated accessors for lessons
extension Group {
    @objc(addLessonsObject:)
    @NSManaged public func addToLessons(_ value: Lesson)
    
    @objc(removeLessonsObject:)
    @NSManaged public func removeFromLessons(_ value: Lesson)
    
    @objc(addLessons:)
    @NSManaged public func addToLessons(_ values: NSSet)
    
    @objc(removeLessons:)
    @NSManaged public func removeFromLessons(_ values: NSSet)
    
}

extension Group: Identifiable { }
extension Group: EducationDated { }
extension Group: LessonsSectioned { }

//MARK: Request
extension Group {
    static func getGroups() -> [Group] {
        let request = self.fetchRequest()
        let employees = try! PersistenceController.shared.container.viewContext.fetch(request)
        
        return employees
    }
    
}

//MARK: Fetch
extension Group {
    static func fetchAllGroups() async {
        let data = try! await URLSession.shared.data(from: FetchDataType.groups.rawValue)
        guard let dictionaries = try! JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
            return
        }
        
        let groups = getGroups()
        
        for dictionary in dictionaries {
            let decoder = JSONDecoder()
            decoder.userInfo[.managedObjectContext] = PersistenceController.shared.container.viewContext
            let data = try! JSONSerialization.data(withJSONObject: dictionary)
            
            if let group = groups.first (where: { $0.id == dictionary["id"] as? String }) {
                var groupp = group
                try! decoder.update(&groupp, from: data)
            } else {
                let _ = try! decoder.decode(Group.self, from: data)
            }
        }
    }
    
}

//MARK: Update
extension Group {
    func update() async -> Group? {
        guard let url = URL(string: FetchDataType.group.rawValue + self.id) else {
            return nil
        }
        let (data, _) = try! await URLSession.shared.data(from: url)
        var employee = self
        let decoder = JSONDecoder()
        decoder.userInfo[.managedObjectContext] = PersistenceController.shared.container.viewContext
        try! decoder.update(&employee, from: data)
        return employee
    }
    static func updateGroups(groups: [Group]) async {
        try! await withThrowingTaskGroup(of: Group?.self) { group in
            for studentGroup in groups {
                group.addTask {
                    await studentGroup.update()
                }
            }
            //Await all tasks
            for try await _ in group { }
        }
    }
    
}
