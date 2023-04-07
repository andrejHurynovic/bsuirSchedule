//
//  Department+CoreDataProperties.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 1.04.23.
//
//

import Foundation
import CoreData


extension Department {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Department> {
        let request = NSFetchRequest<Department>(entityName: "Department")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Department.abbreviation, ascending: true)]
        return request
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var abbreviation: String

    @NSManaged public var auditoriums: NSSet?
    @NSManaged public var employees: NSSet?
    
}

//MARK: - Generated accessors for employees
extension Department {
    
    @objc(addAuditoriumsObject:)
    @NSManaged public func addToAuditoriums(_ value: Auditorium)
    
    @objc(removeAuditoriumsObject:)
    @NSManaged public func removeFromAuditoriums(_ value: Auditorium)
    
    @objc(addAuditoriums:)
    @NSManaged public func addToAuditoriums(_ values: NSSet)
    
    @objc(removeAuditoriums:)
    @NSManaged public func removeFromAuditoriums(_ values: NSSet)
    
    @objc(addEmployeesObject:)
    @NSManaged public func addToEmployees(_ value: Department)
    
    @objc(removeEmployeesObject:)
    @NSManaged public func removeFromEmployees(_ value: Department)
    
    @objc(addEmployees:)
    @NSManaged public func addToEmployees(_ values: NSSet)
    
    @objc(removeEmployees:)
    @NSManaged public func removeFromEmployees(_ values: NSSet)
    
}

extension Department : Identifiable {}

//MARK: - Request

extension Department {
    static func getAll(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) -> [Department] {
        return try! context.fetch(self.fetchRequest())
    }
}

//MARK: - Fetch

extension Department: AbleToFetchAll {
    static func fetchAll() async {
        guard let data = try? await URLSession.shared.data(for: .departments) else { return }
        let startTime = CFAbsoluteTimeGetCurrent()
        
        let (backgroundContext, decoder) = newBackgroundContextWithDecoder()
        
        guard let departments = try? decoder.decode([Department].self, from: data) else {
            Log.error("Can't decode departments.")
            return
        }
        
        await backgroundContext.perform(schedule: .immediate, {
            try! backgroundContext.save()
        })
        Log.info("\(String(departments.count)) Departments fetched, time: \((CFAbsoluteTimeGetCurrent() - startTime).roundTo(places: 3)) seconds.\n")
    }
}
