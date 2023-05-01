//
//  EducationTypeDecoder.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 7.04.23.
//
//

import CoreData

@objc(EducationType)
public class EducationType: NSManagedObject {
    required convenience public init(from decoder: Decoder) throws {
        self.init(context: decoder.userInfo[.managedObjectContext] as! NSManagedObjectContext)
        let container = try! decoder.container(keyedBy: CodingKeys.self)

        self.id = try! container.decode(Int16.self, forKey: .id)
        self.name = try! container.decode(String.self, forKey: .name).capitalized
        
        Log.info("Created EducationType \(self.name) (\(self.id)).")
    }
}

extension EducationType: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}
