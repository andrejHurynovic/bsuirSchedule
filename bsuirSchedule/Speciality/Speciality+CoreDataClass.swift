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
        let entity = NSEntityDescription.entity(forEntityName: "Speciality", in: context)
        self.init(entity: entity!, insertInto: context)
        
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        self.id = try! container.decode(Int32.self, forKey: .id)
        self.name = try! container.decode(String.self, forKey: .name)
        self.abbreviation = try! container.decode(String.self, forKey: .abbreviation)
        
#warning("Что делать в случае отсутствия факультета? А? А?А?А?А?А? Сделать обработку ошибок короче")
//        let facultyID = try! container.decode(Int16.self, forKey: .facultyID)
//        self.faculty = FacultyStorage.shared.faculty(id: facultyID)
        
        let nestedContainer = try! container.nestedContainer(keyedBy: EducationTypeCodingKeys.self, forKey: .educationTypeContainer)
        
        self.educationTypeValue = try! nestedContainer.decode(Int16.self, forKey: .educationTypeId)
        self.code = try! container.decode(String.self, forKey: .code)
    }
    
    convenience public init(context: NSManagedObjectContext, id: Int32, name: String, abbreviation: String, faculty: Faculty) {
        let entity = Speciality.entity()
        self.init(entity: entity, insertInto: context)
        
        self.id = id
        self.name = name
        self.abbreviation = abbreviation
        self.faculty = faculty
    }
    
    static func fetch(specialityCode: String, in context: NSManagedObjectContext) -> Speciality? {
        let request = Speciality.fetchRequest()
        request.predicate = NSPredicate(format: "code == %@", specialityCode)
        guard let specialities = try? context.fetch(request), let speciality = specialities.first else {
            return nil
        }
        return speciality
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
