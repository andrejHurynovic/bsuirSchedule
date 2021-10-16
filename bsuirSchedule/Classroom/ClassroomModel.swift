//
//  ClassroomModel.swift
//  ClassroomModel
//
//  Created by Andrej Hurynovič on 25.09.21.
//

import UIKit

struct ClassroomModel: Decodable {
    
    var name: String!
    var building: Int16!
    var typeValue: Int16!
    
    var departmentName: String?
    var departmentAbbreviation: String?
    
    
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try! container.decode(String.self, forKey: .name)
        
        let buildingContainer = try? container.nestedContainer(keyedBy: BuildingCodingKeys.self, forKey: .buildingContainer)
        self.building = try! buildingContainer!.decode(Int16.self, forKey: .id)
        
        
        let classroomContainer = try? container.nestedContainer(keyedBy: ClassroomCodingKeys.self, forKey: .classroomContainer)
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
    
    private enum CodingKeys: String, CodingKey {
        case name
        case buildingContainer = "buildingNumber"
        case classroomContainer = "auditoryType"
        case departmentContainer = "department"
    }
    
    private enum BuildingCodingKeys: String, CodingKey {
        case id
    }
    private enum ClassroomCodingKeys: String, CodingKey {
        case id
    }
    private enum DepartmentCodingKeys: String, CodingKey {
        case departmentName = "name"
        case departmentAbbreviation = "abbrev"
    }
}
