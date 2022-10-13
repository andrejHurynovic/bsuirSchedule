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
    
    convenience public init(context: NSManagedObjectContext, id: Int32, name: String, abbreviation: String, faculty: Faculty) {
        let entity = Speciality.entity()
        self.init(entity: entity, insertInto: context)
        
        self.id = id
        self.name = name
        self.abbreviation = abbreviation
        self.faculty = faculty
    }
    
}

extension Speciality: Decodable {
    private enum CodingKeys: String, CodingKey {
        
        case id
        case name
        case abbreviation = "abbrev"
        
        case facultyID = "facultyId"
        
        case educationTypeContainer = "educationForm"
        case code
    }
    
    private enum EducationTypeCodingKeys: String, CodingKey {
        case educationTypeId = "id"
    }
}

//MARK: Update
extension Speciality: DecoderUpdatable {
    func update(from decoder: Decoder) throws {
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        let faculties = decoder.userInfo[.faculties] as! [Faculty]

        self.id = try! container.decode(Int32.self, forKey: .id)
        self.name = try! container.decode(String.self, forKey: .name)
        self.abbreviation = try! container.decode(String.self, forKey: .abbreviation)
        
        self.code = try! container.decode(String.self, forKey: .code)
        
        let facultyID = try! container.decode(Int16.self, forKey: .facultyID)
        if let faculty = faculties.first(where: {$0.id == facultyID}) {
            self.faculty = faculty
        } else {
            print(facultyID, name!)
            self.faculty = Faculty(id: facultyID)
        }
        
        let nestedContainer = try! container.nestedContainer(keyedBy: EducationTypeCodingKeys.self, forKey: .educationTypeContainer)
        self.educationTypeValue = try! nestedContainer.decode(Int16.self, forKey: .educationTypeId)
    }
    
}
