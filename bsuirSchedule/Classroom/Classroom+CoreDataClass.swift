//
//  Classroom+CoreDataClass.swift
//  Classroom
//
//  Created by Andrej Hurynovič on 25.09.21.
//
//

import Foundation
import CoreData

@objc(Classroom)
public class Classroom: NSManagedObject {
    
    required convenience init(_ classroom: ClassroomModel) {
        let context = PersistenceController.shared.container.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Classroom", in: context)
        self.init(entity: entity!, insertInto: context)
        
        self.name = classroom.name
        self.building = classroom.building
        self.typeValue = classroom.typeValue
        
        self.departmentName = classroom.departmentName
        self.departmentAbbreviation = classroom.departmentAbbreviation
    }
}
