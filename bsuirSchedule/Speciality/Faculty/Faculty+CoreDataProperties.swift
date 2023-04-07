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

//MARK: - Generated accessors for specialities
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

//MARK: - Request
extension Faculty {
    static func getAll(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) -> [Faculty] {
        return try! context.fetch(self.fetchRequest())
    }
}

//MARK: - Fetch
extension Faculty: AbleToFetchAll {
    static func fetchAll() async {
        guard let data = try? await URLSession.shared.data(for: .faculties) else { return }
        let startTime = CFAbsoluteTimeGetCurrent()
        
        let (backgroundContext, decoder) = newBackgroundContextWithDecoder()
        
        guard let faculties = try? decoder.decode([Faculty].self, from: data) else {
            Log.error("Can't decode faculties.")
            return
        }
        
        await backgroundContext.perform(schedule: .immediate, {
            try! backgroundContext.save()
        })
        Log.info("\(String(faculties.count)) Faculties fetched, time: \((CFAbsoluteTimeGetCurrent() - startTime).roundTo(places: 3)) seconds.\n")
    }
    
}
