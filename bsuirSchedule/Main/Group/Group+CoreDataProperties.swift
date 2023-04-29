//
//  Group+CoreDataProperties.swift
//  Group
//
//  Created by Andrej Hurynovič on 6.09.21.
//
//

import CoreData

extension Group {
    
    @NSManaged public var id: String
    @NSManaged public var numberOfStudents: Int16
    @NSManaged public var educationDegreeValue: Int16
    @NSManaged public var course: Int16
    @NSManaged public var favourite: Bool
    @NSManaged public var lessonsUpdateDate: Date?
    
    @NSManaged public var nickname: String?
    
    @NSManaged public var speciality: Speciality?
    
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

//MARK: - Generated accessors for lessons
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
extension Group: Favored {}
extension Group: EducationDated { }
extension Group: Scheduled {
    var title: String { self.id }
}

//MARK: - Request
extension Group {
    static func getAll(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) -> [Group] {
        try! context.fetch(self.fetchRequest())
    }
}

//MARK: - Fetch
extension Group: AbleToFetchAll {
    static func fetchAll() async {
        let data = try! await URLSession.shared.data(from: FetchDataType.groups.rawValue)
        let startTime = CFAbsoluteTimeGetCurrent()
        guard let dictionaries = try! JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
            Log.error("Can't create group dictionaries.")
            return
        }
        
        let backgroundContext = PersistenceController.shared.container.newBackgroundContext()
        backgroundContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        let decoder = JSONDecoder()
        decoder.userInfo[.managedObjectContext] = backgroundContext
        decoder.userInfo[.groupEmbeddedContainer] = true

        var groups = getAll(context: backgroundContext)
        
        for dictionary in dictionaries {
            let data = try! JSONSerialization.data(withJSONObject: dictionary)
            
            if var group = groups.first (where: { $0.id == dictionary["name"] as? String }) {
                try! decoder.update(&group, from: data)
            } else {
                let group = try! decoder.decode(Group.self, from: data)
                groups.append(group)
            }
        }
        
        await backgroundContext.perform(schedule: .immediate, {
            try! backgroundContext.save()
            Log.info("\(String(groups.count)) Groups fetched, time: \((CFAbsoluteTimeGetCurrent() - startTime).roundTo(places: 3)) seconds.\n")
        })
    }
    
}

//MARK: - Update
extension Group {
    func update() async -> Group? {
        guard let url = URL(string: FetchDataType.group.rawValue + self.id),
              let (data, _) = try? await URLSession.shared.data(from: url) else {
            Log.error("No data for group (\(String(self.id)))")
            return nil
        }
        
        guard data.count != 0 else {
            Log.warning("Empty data while updating group (\(String(self.id)))")
            return nil
        }
        
        let backgroundContext = PersistenceController.shared.container.newBackgroundContext()
        backgroundContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        let decoder = JSONDecoder()
        decoder.userInfo[.managedObjectContext] = backgroundContext
        decoder.userInfo[.groupEmbeddedContainer] = true
        
        var backgroundGroup = backgroundContext.object(with: self.objectID) as! Group
        try! decoder.update(&backgroundGroup, from: data)
        
        await backgroundContext.perform(schedule: .immediate, {
            try! backgroundContext.save()
        })
        
        return self
    }
    
    static func updateGroups(groups: [Group] = Group.getAll()) async {
        let startTime = CFAbsoluteTimeGetCurrent()
        try! await withThrowingTaskGroup(of: Group?.self) { taskGroup in
            for studentGroup in groups {
                taskGroup.addTask {
                    await studentGroup.update()
                }
            }
            try await taskGroup.waitForAll()
        }
        Log.info("Groups updated in time: \((CFAbsoluteTimeGetCurrent() - startTime).roundTo(places: 3)) seconds")

    }
    
}
