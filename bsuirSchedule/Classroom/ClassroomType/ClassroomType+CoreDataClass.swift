//
//  ClassroomType+CoreDataClass.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 1.04.23.
//
//

import Foundation
import CoreData

@objc(ClassroomType)
public class ClassroomType: NSManagedObject {

    required public convenience init(from decoder: Decoder) throws {
        let context = decoder.userInfo[.managedObjectContext] as! NSManagedObjectContext
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        self.init(entity: ClassroomType.entity(), insertInto: context)
        
        self.id = try! container.decode(Int16.self, forKey: .id)
        self.name = try! container.decode(String.self, forKey: .name)
        self.abbreviation = try! container.decode(String.self, forKey: .abbreviation).uppercased()
        
        Log.info("ClassroomType \(self.abbreviation) (\(String(self.id))) has been created.")
    }
    
}

extension ClassroomType: Decodable {
    private enum CodingKeys: String, CodingKey {        
        case id = "id"
        case name = "name"
        case abbreviation = "abbrev"
    }
}
