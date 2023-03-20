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
    static func getAll(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) -> [Speciality] {
        return try! context.fetch(self.fetchRequest())
    }
}

//MARK: Fetch
extension Speciality {
    static func fetchAll() async {
        let data = try! await URLSession.shared.data(from: FetchDataType.specialities.rawValue)
        let startTime = CFAbsoluteTimeGetCurrent()
        
        guard let specialitiesDictionaries = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
            Log.error("Can't create specialities dictionaries.")
            return
        }
        
        let backgroundContext = PersistenceController.shared.container.newBackgroundContext()
        backgroundContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        let decoder = JSONDecoder()
        decoder.userInfo[.managedObjectContext] = backgroundContext
        
        let fetchedFaculties = Faculty.getAll(context: backgroundContext)
        let fetchedSpecialities = Speciality.getAll(context: backgroundContext)
        
        //Сollecting a set of all faculty IDs from specialities information.
        let facultyIDs = Set(specialitiesDictionaries.map { $0["facultyId"] as! Int16 })
        //The Faculty with the corresponding identifier a is searched for.
        let faculties = facultyIDs.map { facultyID in
            if let faculty = fetchedFaculties.first(where: {$0.id == facultyID}) {
                return faculty
            } else {
                //A new Faculty record is created for faculties that are missing in the database.
                Log.warning("Can't find faculty (\(facultyID)), creating new faculty")
                return Faculty(id: facultyID, context: backgroundContext)
            }
        }
        
        //The specialties are filtered by each faculty, after the specialties are created (if they are not presented in the database) and updated.
        for faculty in faculties {
            let facultiesSpecialitiesDictionaries = specialitiesDictionaries.filter { $0["facultyId"] as! Int16 == faculty.id }
            
            let specialities = facultiesSpecialitiesDictionaries.map { specialityDictionary in
                let specialityData = try! JSONSerialization.data(withJSONObject: specialityDictionary)
                let specialityID = specialityDictionary["id"] as! Int32
                var speciality = fetchedSpecialities.first { $0.id == specialityID } ?? Speciality(specialityID, context: backgroundContext)
                try! decoder.update(&speciality, from: specialityData)
                return speciality
            }
            //All filtered specialties are added to the corresponding faculty.
            faculty.addToSpecialities(NSSet(array: specialities))
        }
        await backgroundContext.perform(schedule: .immediate, {
            try! backgroundContext.save()
            Log.info("\(String(self.getAll(context: backgroundContext).count)) Specialities fetched, time: \((CFAbsoluteTimeGetCurrent() - startTime).roundTo(places: 3)) seconds.\n")
        })
    }
}

extension Speciality {
    ///Name + education type + faculty abbreviation
    public override var description: String {
        "\(self.name!) (\(self.educationType.description), \(self.faculty?.abbreviation ?? "Неизвестный факультет"))"
    }
}
