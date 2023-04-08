//
//  Speciality+CoreDataProperties.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 15.10.21.
//
//

import CoreData


extension Speciality {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Speciality> {
        let request = NSFetchRequest<Speciality>(entityName: "Speciality")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Speciality.name, ascending: true),
                                   NSSortDescriptor(keyPath: \Speciality.educationType?.id, ascending: true)]
        return request
    }
    
    @NSManaged public var id: Int32
    @NSManaged public var name: String
    @NSManaged public var abbreviation: String
    
    @NSManaged public var educationType: EducationType?
    @NSManaged public var code: String?
    
    @NSManaged public var faculty: Faculty?
    @NSManaged public var groups: NSSet?
    
}

//MARK: - Generated accessors for groups
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

extension Speciality : Identifiable {}

//MARK: - Request
extension Speciality {
    static func getAll(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) -> [Speciality] {
        return try! context.fetch(self.fetchRequest())
    }
}

//MARK: - Fetch

extension Speciality: AbleToFetchAll {
    static func fetchAll() async {
        guard let data = try? await URLSession.shared.data(for: .specialities) else { return }
        let startTime = CFAbsoluteTimeGetCurrent()
        
        let (backgroundContext, decoder) = newBackgroundContextWithDecoder()
        
        guard let specialities = try? decoder.decode([Speciality].self, from: data) else {
            Log.error("Can't decode specialities.")
            return
        }
        
        await backgroundContext.perform(schedule: .immediate, {
            try! backgroundContext.save()
        })
        Log.info("\(String(specialities.count)) Specialities fetched, time: \((CFAbsoluteTimeGetCurrent() - startTime).roundTo(places: 3)) seconds.\n")
    }
}

extension Speciality {
    ///Name + education type + faculty abbreviation
    public override var description: String {
        "\(self.name) (\(String(describing: self.educationType?.name)), \(self.faculty?.abbreviation ?? "Неизвестный факультет"))"
    }
}
