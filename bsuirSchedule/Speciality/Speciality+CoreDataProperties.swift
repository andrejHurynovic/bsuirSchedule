//
//  Speciality+CoreDataProperties.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 15.10.21.
//
//

import Foundation
import CoreData


extension Speciality {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Speciality> {
        let request = NSFetchRequest<Speciality>(entityName: "Speciality")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Speciality.name, ascending: true),
                                   NSSortDescriptor(keyPath: \Speciality.educationTypeValue, ascending: true)]
        return request
    }
    
    @NSManaged public var id: Int32
    @NSManaged public var name: String!
    @NSManaged public var abbreviation: String!
    
    @NSManaged public var educationTypeValue: Int16
    @NSManaged public var code: String?
    
    @NSManaged public var faculty: Faculty!
    @NSManaged public var groups: NSSet?
    
}

// MARK: Generated accessors for groups
extension Speciality {
    
    @objc(addGroupsObject:)
    @NSManaged public func addToGroups(_ value: Group)
    
    @objc(removeGroupsObject:)
    @NSManaged public func removeFromGroups(_ value: Group)
    
    @objc(addGroups:)
    @NSManaged public func addToGroups(_ values: NSSet)
    
    @objc(removeGroups:)
    @NSManaged public func removeFromGroups(_ values: NSSet)
    
}

extension Speciality : Identifiable {
    
    var educationType: EducationType {
        EducationType(rawValue: educationTypeValue)!
    }
}

//MARK: Request
extension Speciality {
    static func getAll() -> [Speciality] {
        let request = self.fetchRequest()
        let specialities = try! PersistenceController.shared.container.viewContext.fetch(request)

        return specialities
    }

}

//MARK: Fetch
extension Speciality {
    static func fetchAll() async {
        let data = try! await URLSession.shared.data(from: FetchDataType.specialities.rawValue)
        guard let dictionaries = try! JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
            return
        }
        
        let specialities = getAll()
        
        let decoder = JSONDecoder()
        decoder.userInfo[.managedObjectContext] = PersistenceController.shared.container.viewContext
        
        //For faculties not presented in API
        var faculties = Faculty.getAll()
        for dictionary in dictionaries {
            let facultyID = dictionary["facultyId"] as! Int16
            if faculties.first(where: {$0.id == facultyID}) == nil {
                faculties.append(Faculty(id: facultyID))
            }
        }
        try! PersistenceController.shared.container.viewContext.save()
        
        decoder.userInfo[.faculties] = faculties
        for dictionary in dictionaries {
            let data = try! JSONSerialization.data(withJSONObject: dictionary)
            
            let id = dictionary["id"] as! Int32
            
            if let specialty = specialities.first (where: { $0.id == id }) {
                var mutableSpecialty = specialty
                try! decoder.update(&mutableSpecialty, from: data)
            } else {
                let _ = try? decoder.decode(Speciality.self, from: data)
            }
        }
    }
    
}


extension Speciality {
    ///Name + education type + faculty abbreviation
    public override var description: String {
        "\(self.name!) (\(self.educationType.description), \(self.faculty!.abbreviation!))"
    }
}
