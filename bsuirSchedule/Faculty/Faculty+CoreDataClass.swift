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
        
        //If init is called from a decoder that decodes a Group and cannot find the required specialty, a special method is called to process specific Group keys.
        if let decodingSpecialityFromGroup = decoder.userInfo[.decodingSpecialityFromGroup] as? Bool,
           decodingSpecialityFromGroup == true {
            try! self.updateFromGroupDecoder(decoder)
        } else {
            try! self.update(from: decoder)
        }
    }
    
    convenience public init(id: Int16, name: String? = nil, abbreviation: String? = nil, context: NSManagedObjectContext) {
        self.init(entity: Faculty.entity(), insertInto: context)
        
        self.id = id
        self.name = name
        self.abbreviation = abbreviation
    }
    
}

//MARK: Update
extension Faculty: DecoderUpdatable {
    func update(from decoder: Decoder) throws {
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try! container.decode(Int16.self, forKey: .id)
        self.name = try! container.decode(String.self, forKey: .name)
        self.abbreviation = try! container.decode(String.self, forKey: .abbreviation)
        Log.info("Faculty \(self.abbreviation!) (\(String(self.id))) has been updated")
    }
    
    func updateFromGroupDecoder(_ decoder: Decoder) throws {
        let container = try! decoder.container(keyedBy: GroupCodingKeys.self)
        
        self.id = try! container.decode(Int16.self, forKey: .id)
        self.abbreviation = try! container.decode(String.self, forKey: .abbreviation)
        Log.info("Faculty \(self.abbreviation!) (\(String(self.id))) has been created from Group container")
    }
    
}

extension Faculty: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case abbreviation = "abbrev"
    }
    
    private enum GroupCodingKeys: String, CodingKey {
        case id = "facultyId"
        case abbreviation = "facultyAbbrev"
    }
}


