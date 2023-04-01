//
//  Classroom+CoreDataProperties.swift
//  Classroom
//
//  Created by Andrej Hurynovič on 25.09.21.
//
//

import Foundation
import CoreData

extension Classroom {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Classroom> {
        let request = NSFetchRequest<Classroom>(entityName: "Classroom")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Classroom.name, ascending: true)]
        return request
    }

    @NSManaged public var floor: Int16
    @NSManaged public var name: String!
    ///Used for constraints and effective search when decoding Lessons.
    @NSManaged public var note: String?
    @NSManaged public var favourite: Bool
    
    @NSManaged public var outsideUniversity: Bool
    @NSManaged public var building: Int16
    @NSManaged public var capacity: Int16
    
    @NSManaged public var type: ClassroomType
    @NSManaged public var department: Department?
    
    @NSManaged public var lessons: NSSet?
    
}

// MARK: Generated accessors for lessons
extension Classroom {

    @objc(addLessonsObject:)
    @NSManaged public func addToLessons(_ value: Lesson)

    @objc(removeLessonsObject:)
    @NSManaged public func removeFromLessons(_ value: Lesson)

    @objc(addLessons:)
    @NSManaged public func addToLessons(_ values: NSSet)

    @objc(removeLessons:)
    @NSManaged public func removeFromLessons(_ values: NSSet)

}

extension Classroom: LessonsSectioned { }
extension Classroom: Identifiable {}

extension Classroom: EducationDated {
    var educationStart: Date? {
        get {
            self.groups.compactMap { $0.educationStart }.sorted().first
        }
        set { }
    }
    var educationEnd: Date? {
        get {
            self.groups.compactMap { $0.educationEnd }.sorted().last
        }
        set { }
    }
    var examsStart: Date? {
        get {
            self.groups.compactMap { $0.examsStart }.sorted().first
        }
        set { }
    }
    var examsEnd: Date? {
        get {
            self.groups.compactMap { $0.examsEnd }.sorted().last
        }
        set { }
    }

}

//MARK: Request
extension Classroom {
    static func getAll(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) -> [Classroom] {
        try! context.fetch(self.fetchRequest())
    }
}

//MARK: Fetch
extension Classroom {
    static func fetchAll() async {
        let data = try! await URLSession.shared.data(from: FetchDataType.classrooms.rawValue)
        let startTime = CFAbsoluteTimeGetCurrent()
        
        guard let dictionaries = try! JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
            Log.error("Can't create classrooms dictionaries.")
            return
        }
        
        let backgroundContext = PersistenceController.shared.container.newBackgroundContext()
        backgroundContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        let decoder = JSONDecoder()
        decoder.userInfo[.managedObjectContext] = backgroundContext
        
        let classrooms = getAll(context: backgroundContext)
        
        for dictionary in dictionaries {
            let data = try! JSONSerialization.data(withJSONObject: dictionary)
            
            let name = dictionary["name"] as! String
            let buildingDictionary = dictionary["buildingNumber"] as! [String: Any]
            let buildingString = buildingDictionary["name"] as! String
            
                        
            if let building = try? Classroom.decodeBuilding(string: buildingString),
               let nameParts = try? Classroom.decodeName(string: name),
               var classroom = classrooms.first (where: {
                   $0.building == building &&
                   $0.floor == nameParts.floor &&
                   $0.name == nameParts.name
               }) {
                try! decoder.update(&classroom, from: data)
            } else {
                let _ = try? decoder.decode(Classroom.self, from: data)
            }
        }
        await backgroundContext.perform(schedule: .immediate, {
            try! backgroundContext.save()
            Log.info("\(String(self.getAll(context: backgroundContext).count)) Classrooms fetched, time: \((CFAbsoluteTimeGetCurrent() - startTime).roundTo(places: 3)) seconds.\n")
        })
    }
    
}

//MARK: Accessors
extension Classroom {
    var groups: [Group] {
        let lessons = lessons?.allObjects as! [Lesson]
        let groups = Array(lessons.compactMap {($0.groups?.allObjects as! [Group])}.joined())
        return Set(groups).sorted { $0.id < $1.id }
    }
    
}

//MARK: Formatted name
extension Classroom {
    func formattedName(showBuilding: Bool) -> String {
        if outsideUniversity == true {
            //Оutside university buildings
            //"Транзистор", "epam-104", "Столовая"
            return self.name
        } else {
            if showBuilding {
                //321-4
                return String(self.floor) + self.name + "-" + String(self.building)
            } else {
                //321
                return String(self.floor) + self.name
            }
        }
    }
    
}
