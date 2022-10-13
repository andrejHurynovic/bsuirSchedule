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

// MARK: Generated accessors for specialities
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
    static func getAll() -> [Faculty] {
        let request = self.fetchRequest()
        let faculties = try! PersistenceController.shared.container.viewContext.fetch(request)

        return faculties
    }

}

//MARK: Fetch
extension Faculty {
    static func fetchAll() async {
        let data = try! await URLSession.shared.data(from: FetchDataType.faculties.rawValue)
        guard let dictionaries = try! JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
            return
        }
        
        let faculties = getAll()
        
        for dictionary in dictionaries {
            let decoder = JSONDecoder()
            decoder.userInfo[.managedObjectContext] = PersistenceController.shared.container.viewContext
            let data = try! JSONSerialization.data(withJSONObject: dictionary)
            
            let id = dictionary["id"] as! Int16
            
            if let faculty = faculties.first (where: { $0.id == id }) {
                var mutableFaculty = faculty
                try! decoder.update(&mutableFaculty, from: data)
            } else {
                let _ = try? decoder.decode(Faculty.self, from: data)
            }
        }
    }
    
}
