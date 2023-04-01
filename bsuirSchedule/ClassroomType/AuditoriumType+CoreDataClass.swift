//
//  AuditoriumType+CoreDataClass.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 1.04.23.
//
//

import Foundation
import CoreData

@objc(AuditoriumType)
public class AuditoriumType: NSManagedObject {

    required public convenience init(from decoder: Decoder) throws {
        let context = decoder.userInfo[.managedObjectContext] as! NSManagedObjectContext
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        self.init(entity: AuditoriumType.entity(), insertInto: context)
        
        self.id = try! container.decode(Int16.self, forKey: .id)
        self.name = try! container.decode(String.self, forKey: .name).capitalizingFirstLetter()
        self.abbreviation = try! container.decode(String.self, forKey: .abbreviation).uppercased()
        
        Log.info("AuditoriumType \(self.abbreviation) (\(String(self.id))) has been created.")
    }
    
}

extension AuditoriumType: Decodable {
    private enum CodingKeys: String, CodingKey {        
        case id = "id"
        case name = "name"
        case abbreviation = "abbrev"
    }
}
