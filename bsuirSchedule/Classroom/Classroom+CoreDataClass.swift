//
//  Classroom+CoreDataClass.swift
//  Classroom
//
//  Created by Andrej Hurynovič on 25.09.21.
//
//

import Foundation
import CoreData

@objc(Classroom)
public class Classroom: NSManagedObject, Decodable {
    
    required convenience public init(from decoder: Decoder) throws {
        let context = PersistenceController.shared.container.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Classroom", in: context)
        self.init(entity: entity!, insertInto: context)
        
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        
        self.originalName = try! container.decode(String.self, forKey: .name)
        
        let name = try! container.decode(String.self, forKey: .name)
        let buildingContainer = try! container.nestedContainer(keyedBy: BuildingCodingKeys.self, forKey: .buildingContainer)
        let buildingString = try! buildingContainer.decode(String.self, forKey: .name)
        
        let result = ClassroomStorage.nameAndBuildingProbably(name: name, buildingString: buildingString)
        self.floor = result.floor
        self.name = result.name
        self.building = result.building
        
        let classroomContainer = try? container.nestedContainer(keyedBy: ClassroomCodingKeys.self, forKey: .typeContainer)
        self.typeValue = try! classroomContainer!.decode(Int16.self, forKey: .id)
        
        
        if let nestedContainer = try? container.nestedContainer(keyedBy: DepartmentCodingKeys.self, forKey: .departmentContainer) {
            self.departmentName = try! nestedContainer.decode(String.self, forKey: .departmentName)
            
            var departmentAbbreviation = try! nestedContainer.decode(String.self, forKey: .departmentAbbreviation)
            if let range = departmentAbbreviation.range(of: "каф.") {
                departmentAbbreviation.removeSubrange(range)
            }
            self.departmentAbbreviation = departmentAbbreviation.trimmingCharacters(in: .whitespaces)
        }
    }
    
    func formattedName(showBuilding: Bool) -> String {
        if showBuilding {
            if building == 99 {
                return self.name
            } else {
                return String(self.floor) + self.name + "-" + String(self.building)
            }
        } else {
            if building == 99 {
                return self.name
            } else {
                return String(self.floor) + self.name
            }
        }
    }
    
    
    func classroomTypeDescription() -> String {
        switch self.typeValue {
        case 1:
            return "ЛК"
        case 2:
            return "ПЗ"
        case 3:
            return "ЛР"
        case 4:
            return "КК"
        case 5:
            return "ВП"
        case 6:
            return "РК"
        case 7:
            return "НЛ"
        default:
            return ""
        }
    }
    
    static func classroomTypeDescription(_ value: Int) -> String {
        switch value {
        case 1:
            return "ЛК"
        case 2:
            return "ПЗ"
        case 3:
            return "ЛР"
        case 4:
            return "КК"
        case 5:
            return "ВП"
        case 6:
            return "РК"
        case 7:
            return "НЛ"
        default:
            return ""
        }
    }
    
    
    private enum CodingKeys: String, CodingKey {
        case name
        case buildingContainer = "buildingNumber"
        case typeContainer = "auditoryType"
        case departmentContainer = "department"
    }
    
    private enum BuildingCodingKeys: String, CodingKey {
        case name
    }
    private enum ClassroomCodingKeys: String, CodingKey {
        case id
    }
    private enum DepartmentCodingKeys: String, CodingKey {
        case departmentName = "name"
        case departmentAbbreviation = "abbrev"
    }
    
}
