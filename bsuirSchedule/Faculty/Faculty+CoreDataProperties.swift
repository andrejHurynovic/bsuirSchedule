//
//  Faculty+CoreDataProperties.swift
//  Faculty
//
//  Created by Andrej Hurynovič on 21.09.21.
//
//

import Foundation
import CoreData


extension Faculty {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Faculty> {
        let request = NSFetchRequest<Faculty>(entityName: "Faculty")
        request.sortDescriptors = []
        return request
    }
    
    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var abbreviation: String?
    
    @NSManaged public var specialities: NSSet?
    
}

//MARK: Generated accessors for specialities
extension Faculty {
    
    @objc(addSpecialitiesObject:)
    @NSManaged public func addToSpecialities(_ value: Speciality)
    
    @objc(removeSpecialitiesObject:)
    @NSManaged public func removeFromSpecialities(_ value: Speciality)
    
    @objc(addSpecialities:)
    @NSManaged public func addToSpecialities(_ values: NSSet)
    
    @objc(removeSpecialities:)
    @NSManaged public func removeFromSpecialities(_ values: NSSet)
    
}

extension Faculty : Identifiable {}

//MARK: Request
extension Faculty {
    static func getAll(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) -> [Faculty] {
        return try! context.fetch(self.fetchRequest())
    }
    
}

//MARK: Fetch
extension Faculty {
    static func fetchAll() async {
        let data = try! await URLSession.shared.data(from: FetchDataType.faculties.rawValue)
        let startTime = CFAbsoluteTimeGetCurrent()
        
        guard let facultiesDictionaries = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
            Log.error("Can't create faculties dictionaries.")
            return
        }
        
        let backgroundContext = PersistenceController.shared.container.newBackgroundContext()
        backgroundContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        let decoder = JSONDecoder()
        decoder.userInfo[.managedObjectContext] = backgroundContext
        
        let fetchedFaculties = Faculty.getAll(context: backgroundContext)
        
        let faculties = facultiesDictionaries.map { facultiesDictionary in
            let facultyID = facultiesDictionary["id"] as! Int16
            //Creates faculties that are not presented in the database.
            var faculty = fetchedFaculties.first { $0.id == facultyID } ?? Faculty(id: facultyID, context: backgroundContext)
            let facultyData = try! JSONSerialization.data(withJSONObject: facultiesDictionary)
            try! decoder.update(&faculty, from: facultyData)
            return faculty
        }
        await backgroundContext.perform(schedule: .immediate, {
            try! backgroundContext.save()
        })
        Log.info("\(String(faculties.count)) Faculties fetched, time: \((CFAbsoluteTimeGetCurrent() - startTime).roundTo(places: 3)) seconds.\n")
    }
    
}
