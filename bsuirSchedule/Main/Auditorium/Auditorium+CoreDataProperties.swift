//
//  Auditorium+CoreDataProperties.swift
//  Auditorium
//
//  Created by Andrej Hurynovič on 25.09.21.
//
//

import CoreData

extension Auditorium {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Auditorium> {
        let request = NSFetchRequest<Auditorium>(entityName: "Auditorium")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Auditorium.building, ascending: true),
                                   NSSortDescriptor(keyPath: \Auditorium.formattedName, ascending: true)]
        return request
    }
    
    @NSManaged public var floor: Int16
    @NSManaged public var name: String
    @NSManaged public var formattedName: String
    ///Used for constraints and effective search when decoding Lessons.
    @NSManaged public var note: String?
    @NSManaged public var favourite: Bool
    
    @NSManaged public var outsideUniversity: Bool
    @NSManaged public var building: Int16
    @NSManaged public var capacity: Int16
    
    @NSManaged public var type: AuditoriumType?
    @NSManaged public var department: Department?
    
    @NSManaged public var lessons: NSSet?
    
}

//MARK: - Generated accessors for lessons
extension Auditorium {
    
    @objc(addLessonsObject:)
    @NSManaged public func addToLessons(_ value: Lesson)
    
    @objc(removeLessonsObject:)
    @NSManaged public func removeFromLessons(_ value: Lesson)
    
    @objc(addLessons:)
    @NSManaged public func addToLessons(_ values: NSSet)
    
    @objc(removeLessons:)
    @NSManaged public func removeFromLessons(_ values: NSSet)
    
}

extension Auditorium: Identifiable {}
extension Auditorium: Favored {}
extension Auditorium: Scheduled {
    var title: String { self.formattedName }
}

extension Auditorium: EducationDated {
    var educationStart: Date? {
        get {
            self.groups?.compactMap { $0.educationStart }.sorted().first
        }
        set { }
    }
    var educationEnd: Date? {
        get {
            self.groups?.compactMap { $0.educationEnd }.sorted().last
        }
        set { }
    }
    var examsStart: Date? {
        get {
            self.groups?.compactMap { $0.examsStart }.sorted().first
        }
        set { }
    }
    var examsEnd: Date? {
        get {
            self.groups?.compactMap { $0.examsEnd }.sorted().last
        }
        set { }
    }
    
}

//MARK: - Request
extension Auditorium {
    static func getAll(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) -> [Auditorium] {
        try! context.fetch(self.fetchRequest())
    }
}

//MARK: - Fetch
extension Auditorium: AbleToFetchAll {
    static func fetchAll() async {
        guard let data = try? await URLSession.shared.data(for: .auditoriums) else { return }
        let startTime = CFAbsoluteTimeGetCurrent()
        
        guard let dictionaries = try! JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
            Log.error("Can't create auditoriums dictionaries.")
            return
        }
        
        let backgroundContext = PersistenceController.shared.container.newBackgroundContext()
        backgroundContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        let decoder = JSONDecoder()
        decoder.userInfo[.managedObjectContext] = backgroundContext
        
        let auditoriums = getAll(context: backgroundContext)
        //This is required because decoder actually can throw an error here, so we can't decode whole array instantly.
        for dictionary in dictionaries {
            let data = try! JSONSerialization.data(withJSONObject: dictionary)
            
            let name = dictionary["name"] as! String
            let buildingDictionary = dictionary["buildingNumber"] as! [String: Any]
            let buildingString = buildingDictionary["name"] as! String
            
            
            if var auditorium = auditoriums.first (where: {
                if $0.outsideUniversity {
                    return "\($0.name)-\($0.building)" == "\(name)-\(buildingString.first!)"
                } else {
                    return  $0.formattedName == "\(name)-\(buildingString.first!)"
                }
            }) {
                try? decoder.update(&auditorium, from: data)
            } else {
                let _ = try? decoder.decode(Auditorium.self, from: data)
            }
        }
        await backgroundContext.perform(schedule: .immediate, {
            try! backgroundContext.save()
            Log.info("\(String(self.getAll(context: backgroundContext).count)) Auditoriums fetched, time: \((CFAbsoluteTimeGetCurrent() - startTime).roundTo(places: 3)) seconds.\n")
        })
    }
    
}

//MARK: - Accessors
extension Auditorium {
    var groups: [Group]? {
        guard let lessons = lessons?.allObjects as? [Lesson], !lessons.isEmpty else {
            return nil
        }
        let groups = Array(lessons.compactMap {($0.groups?.allObjects as! [Group])}.joined())
        return Set(groups).sorted { $0.id < $1.id }
    }
    
}
