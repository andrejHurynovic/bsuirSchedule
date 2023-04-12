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
        self.init(context: decoder.userInfo[.managedObjectContext] as! NSManagedObjectContext)
        
        //If init is called from a decoder that decodes a Group and cannot find the required specialty, a special method is called to process specific Group keys.
        if let groupContainer = decoder.userInfo[.groupEmbeddedContainer] as? Bool,
           groupContainer == true {
            try! self.updateFromGroupDecoder(decoder)
        } else {
            try! self.update(from: decoder)
        }
    }
    
}

//MARK: - Update
extension Speciality: DecoderUpdatable {
    func update(from decoder: Decoder) throws {
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try! container.decode(Int32.self, forKey: .id)
        self.name = try! container.decode(String.self, forKey: .name)
        self.abbreviation = try! container.decode(String.self, forKey: .abbreviation)
        
        self.code = try! container.decode(String.self, forKey: .code)
        
        self.educationType = try! container.decode(EducationType.self, forKey: .educationTypeContainer)
        
        if let facultyID = try? container.decode(Int16.self, forKey: .facultyID),
           let context = decoder.userInfo[.managedObjectContext] as? NSManagedObjectContext {
            self.faculty =  Faculty(id: facultyID, context: context)
        }
        
        Log.info("Speciality \(self.id) (\(self.abbreviation)) has been updated.")
    }
    
    func updateFromGroupDecoder(_ decoder: Decoder) throws {
        //If the decoder container is received from a Groups API call, the Speciality information is contained in root, but if it is received from a Group API call, the required information is contained in a nested container.
        let container = (try? decoder.container(keyedBy: GroupCodingKeys.self)
            .nestedContainer(keyedBy: GroupCodingKeys.self, forKey: .groupNestedContainer))
        ?? (try! decoder.container(keyedBy: GroupCodingKeys.self))
        
        self.id = try! container.decode(Int32.self, forKey: .id)
        self.name = try! container.decode(String.self, forKey: .name)
        self.abbreviation = try! container.decode(String.self, forKey: .abbreviation)
        
        self.faculty = try! Faculty(from: decoder)
        
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
    
    private enum GroupCodingKeys: String, CodingKey {
        case groupNestedContainer = "studentGroupDto"
        
        case id = "specialityDepartmentEducationFormId"
        case name = "specialityName"
        case abbreviation = "specialityAbbrev"
    }
    
    private enum EducationTypeCodingKeys: String, CodingKey {
        case educationTypeId = "id"
    }
}

