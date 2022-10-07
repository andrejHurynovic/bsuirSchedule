//
//  Week+CoreDataClass.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 30.05.22.
//
//

import Foundation
import CoreData

@objc(Week)
public class Week: NSManagedObject, Decodable {
    
    required convenience public init(from decoder: Decoder) throws {
        
        let context = PersistenceController.shared.container.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Week", in: context)
        self.init(entity: entity!, insertInto: context)
        
        //-1 для приведения к виду [0,3], вместо [1,4]
        self.updatedWeek = try! decoder.singleValueContainer().decode(Int16.self) - 1
        self.updateDate = Date()
    }
    
    convenience init() {
        let context = PersistenceController.shared.container.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Week", in: context)
        self.init(entity: entity!, insertInto: context)
        
        //-1 для приведения к виду [0,3], вместо [1,4]
        self.updatedWeek = 0
        self.updateDate = Date()
    }
}
