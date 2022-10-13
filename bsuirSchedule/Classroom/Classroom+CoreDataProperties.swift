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
    @NSManaged public var originalName: String!
    @NSManaged public var favourite: Bool
    
    @NSManaged public var outsideUniversity: Bool
    @NSManaged public var building: Int16
    
    @NSManaged public var typeValue: Int16
    
    @NSManaged public var departmentName: String?
    @NSManaged public var departmentAbbreviation: String?
    
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

//MARK: Identifiable
extension Classroom: Identifiable {
    var type: ClassroomType {
        ClassroomType(rawValue: typeValue)!
    }
}

//MARK: EducationDates
extension Classroom: EducationDated {
    var educationStart: Date? {
        self.groups.compactMap { $0.educationStart }.sorted().first
    }
    var educationEnd: Date? {
        self.groups.compactMap { $0.educationEnd }.sorted().last
    }
    var examsStart: Date? {
        self.groups.compactMap { $0.examsStart }.sorted().first
    }
    var examsEnd: Date? {
        self.groups.compactMap { $0.examsEnd }.sorted().last
    }

}

//MARK: Request
extension Classroom {
    static func getClassrooms() -> [Classroom] {
        let request = self.fetchRequest()
        let classrooms = try! PersistenceController.shared.container.viewContext.fetch(request)
        
        return classrooms
    }
    
}

//MARK: Fetch
extension Classroom {
    static func fetchAll() async {
        let data = try! await URLSession.shared.data(from: FetchDataType.classrooms.rawValue)
        guard let dictionaries = try! JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
            return
        }
        
        let classrooms = getClassrooms()
        
        for dictionary in dictionaries {
            let decoder = JSONDecoder()
            decoder.userInfo[.managedObjectContext] = PersistenceController.shared.container.viewContext
            let data = try! JSONSerialization.data(withJSONObject: dictionary)
            
            let name = dictionary["name"] as! String
            
            let buildingDictionary = dictionary["buildingNumber"] as! [String: Any]
            let buildingString = buildingDictionary["name"] as! String
            let originalName = "\(name)-\(buildingString)"
            
            if let classroom = classrooms.first (where: { $0.originalName == originalName }) {
                var classroome = classroom
                try! decoder.update(&classroome, from: data)
            } else {
                let _ = try? decoder.decode(Classroom.self, from: data)
            }
        }
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
