//
//  Faculty+CoreDataClass.swift
//  Faculty
//
//  Created by Andrej Hurynovič on 21.09.21.
//
//

import Foundation
import CoreData

@objc(Faculty)
public class Faculty: NSManagedObject, Decodable {
    
    required convenience public init(from decoder: Decoder) throws {
        let context = PersistenceController.shared.container.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Faculty", in: context)
        self.init(entity: entity!, insertInto: context)
        
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try! container.decode(Int16.self, forKey: .id)
        self.name = try! container.decode(String.self, forKey: .name)
        self.abbreviation = try! container.decode(String.self, forKey: .abbreviation)
    }
    
    convenience public init(id: Int16, abbreviation: String) {
        let context = PersistenceController.shared.container.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Faculty", in: context)
        self.init(entity: entity!, insertInto: context)
        
        self.id = id
        self.abbreviation = abbreviation
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case abbreviation = "abbrev"
    }
}
