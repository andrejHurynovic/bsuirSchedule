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
public class Faculty: NSManagedObject {
 
    required convenience public init(from decoder: Decoder) throws {
        let context = decoder.userInfo[.managedObjectContext] as! NSManagedObjectContext
        self.init(entity: Faculty.entity(), insertInto: context)
        
        try! self.update(from: decoder)
    }
    
    convenience public init(id: Int16, name: String? = nil, abbreviation: String? = nil) {
        let context = PersistenceController.shared.container.viewContext
        self.init(entity: Faculty.entity(), insertInto: context)
        
        self.id = id
        if let name = name {
            self.name = name
        }
        if let abbreviation = abbreviation {
            self.abbreviation = abbreviation
        }
    }
    
}

//MARK: Update
extension Faculty: DecoderUpdatable {
    func update(from decoder: Decoder) throws {
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try! container.decode(Int16.self, forKey: .id)
        self.name = try! container.decode(String.self, forKey: .name)
        self.abbreviation = try! container.decode(String.self, forKey: .abbreviation)
        Log.info("Faculty \(self.abbreviation ?? "Empty name") (\(String(self.id))) has been updated)")
    }
    
}

extension Faculty: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case abbreviation = "abbrev"
    }
}

//MARK: CodingUserInfoKey
extension CodingUserInfoKey {
    static let faculties = CodingUserInfoKey(rawValue: "faculties")!
}

