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
    
    @NSManaged public var nickname: String?
    
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
    static func getAll() -> [Group] {
        let request = self.fetchRequest()
        let employees = try! PersistenceController.shared.container.viewContext.fetch(request)
        
        return employees
    }
    
}

//MARK: Fetch
extension Group {
    static func fetchAll() async {
        let data = try! await URLSession.shared.data(from: FetchDataType.groups.rawValue)
        guard let dictionaries = try! JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
            return
        }
        
        let groups = getAll()
        
        let decoder = JSONDecoder()
        decoder.userInfo[.managedObjectContext] = PersistenceController.shared.container.viewContext
        decoder.userInfo[.specialities] = Speciality.getAll()
        for dictionary in dictionaries {
            let data = try! JSONSerialization.data(withJSONObject: dictionary)
            
            if let group = groups.first (where: { $0.id == dictionary["id"] as? String }) {
                var mutableGroup = group
                try! decoder.update(&mutableGroup, from: data)
            } else {
                let _ = try! decoder.decode(Group.self, from: data)
            }
        }
    }
    
}

//MARK: Update
extension Group {
    func update(decoder: JSONDecoder? = nil) async -> Group? {
        guard let url = URL(string: FetchDataType.group.rawValue + self.id) else {
            return nil
        }
        let (data, _) = try! await URLSession.shared.data(from: url)
        var group = self
        
        guard data.count != 0 else {
            return nil
        }
        
        var decoder = decoder
        if decoder == nil {
            decoder = JSONDecoder()
            decoder!.userInfo[.managedObjectContext] = PersistenceController.shared.container.viewContext
            decoder!.userInfo[.groups] = Group.getAll()
            decoder!.userInfo[.employees] = Employee.getAll()
            decoder!.userInfo[.classrooms] = Classroom.getAll()
            decoder!.userInfo[.specialities] = Speciality.getAll()
        }
        
        try! decoder!.update(&group, from: data)
        return group
    }
    
    static func updateGroups(groups: [Group]) async {
        let decoder = JSONDecoder()
        decoder.userInfo[.managedObjectContext] = PersistenceController.shared.container.viewContext
        decoder.userInfo[.groups] = Group.getAll()
        decoder.userInfo[.employees] = Employee.getAll()
        decoder.userInfo[.classrooms] = Classroom.getAll()
        decoder.userInfo[.specialities] = Speciality.getAll()
        
        try! await withThrowingTaskGroup(of: Group?.self) { group in
            for studentGroup in groups {
                group.addTask {
                    await studentGroup.update(decoder: decoder)
                }
            }
            //Await all tasks
            for try await _ in group { }
        }
    }
    
}

//MARK: Accessors
extension Group {
    var employees: [Employee]? {
        guard let lessons = self.lessons?.allObjects as? [Lesson] else {
            return nil
        }
        let employees = Array(lessons.compactMap {($0.employees?.allObjects as! [Employee])}.joined())
        let sortedEmployees = Set(employees).sorted { $0.lastName < $1.lastName }
        guard sortedEmployees.isEmpty == false else {
            return nil
        }
        return sortedEmployees
    }
    
    var flow: [Group]? {
        guard var flow = self.speciality.groups?.allObjects as? [Group] else {
            return nil
        }
        flow.removeAll { $0.course != self.course || $0 == self }

        guard flow.isEmpty == false else {
            return nil
        }
        return flow.sorted { $0.id! < $1.id }
    }
    
}
