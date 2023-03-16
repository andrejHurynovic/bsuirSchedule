//
//  Speciality+CoreDataClass.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 15.10.21.
//
//

import Foundation
import CoreData

@objc(Speciality)
public class Speciality: NSManagedObject {
    
    required convenience public init(from decoder: Decoder) throws {
        let context = decoder.userInfo[.managedObjectContext] as! NSManagedObjectContext
        self.init(entity: Speciality.entity(), insertInto: context)
        
        try! self.update(from: decoder)
    }
    
    convenience public init(_ id: Int32, _ name: String? = nil, _ abbreviation: String? = nil, _ faculty: Faculty? = nil) {
        let entity = Speciality.entity()
        self.init(entity: entity, insertInto: PersistenceController.shared.container.viewContext)
        
        self.id = id
        self.name = name
        self.abbreviation = abbreviation
        self.faculty = faculty
    }
    
}

//MARK: Update
extension Speciality: DecoderUpdatable {
    func update(from decoder: Decoder) throws {
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try! container.decode(Int32.self, forKey: .id)
        self.name = try! container.decode(String.self, forKey: .name)
        self.abbreviation = try! container.decode(String.self, forKey: .abbreviation)
        
        self.code = try! container.decode(String.self, forKey: .code)
        
        let educationTypeContainer = try! container.nestedContainer(keyedBy: EducationTypeCodingKeys.self, forKey: .educationTypeContainer)
        self.educationTypeValue = try! educationTypeContainer.decode(Int16.self, forKey: .educationTypeId)
        
        Log.info("Speciality \(self.id) (\(self.abbreviation ?? "Empty name")) has been updated")
    }
}

extension Speciality: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case abbreviation = "abbrev"
        
        case code
        
        case facultyID = "facultyId"
        
        case educationTypeContainer = "educationForm"
    }
    
    private enum EducationTypeCodingKeys: String, CodingKey {
        case educationTypeId = "id"
    }
}

//MARK: CodingUserInfoKey
extension CodingUserInfoKey {
    static let specialities = CodingUserInfoKey(rawValue: "specialities")!
}
