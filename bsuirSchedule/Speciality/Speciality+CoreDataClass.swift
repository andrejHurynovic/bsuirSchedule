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
public class Speciality: NSManagedObject, Decodable {
    
    required convenience public init(from decoder: Decoder) throws {
        
        let context = PersistenceController.shared.container.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Speciality", in: context)
        self.init(entity: entity!, insertInto: context)
        
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        self.id = try! container.decode(Int32.self, forKey: .id)
        self.name = try! container.decode(String.self, forKey: .name)
        self.abbreviation = try! container.decode(String.self, forKey: .abbreviation)
        
        let facultyID = try! container.decode(Int.self, forKey: .facultyID)
        self.faculty = FacultyStorage.shared.values.value.first(where: {$0.id == facultyID})
        
        let nestedContainer = try! container.nestedContainer(keyedBy: EducationTypeCodingKeys.self, forKey: .educationTypeContainer)
        
        self.educationTypeValue = try! nestedContainer.decode(Int16.self, forKey: .educationTypeValue)
        self.code = try! container.decode(String.self, forKey: .code)
    }
    
    func getEducationTypeDescription() -> String {
        switch self.educationTypeValue {
        case 1:
            return "дневная"
        case 2:
            return "заочная"
        case 3:
            return "дистанционная"
        case 4:
            return "вечерняя"
        default:
            return ""
        }
    }
}


private enum CodingKeys: String, CodingKey {
    
    case id
    case name
    case abbreviation = "abbrev"
    
    case facultyID = "facultyId"
    
    case educationTypeContainer = "educationForm"
    case code
}

private enum EducationTypeCodingKeys: String, CodingKey {
    case educationTypeValue = "id"
}
