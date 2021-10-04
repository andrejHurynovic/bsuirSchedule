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


//// This file was generated from JSON Schema using quicktype, do not modify it directly.
//// To parse the JSON, add this file to your project and do:
////
////   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)
//
//import Foundation
//
//// MARK: - WelcomeElement
//struct WelcomeElement: Codable {
//    let id: Int
//    let name: String
//    let note: Note?
//    let capacity: Int?
//    let auditoryType: AuditoryType
//    let buildingNumber: BuildingNumber
//    let department: Department?
//}
//
//// MARK: - AuditoryType
//struct AuditoryType: Codable {
//    let id: Int
//    let name: AuditoryTypeName
//    let abbrev: Abbrev
//}
//
//enum Abbrev: String, Codable {
//    case вп = "вп"
//    case кк = "кк"
//    case лб = "лб"
//    case лк = "лк"
//    case нл = "нл"
//    case пз = "пз"
//    case рк = "рк"
//}
//
//enum AuditoryTypeName: String, Codable {
//    case вспомогательноеПомещение = "вспомогательное помещение"
//    case компьютерныйКласс = "компьютерный класс"
//    case лабораторныеЗанятия = "лабораторные занятия"
//    case лекционная = "лекционная"
//    case научнаяЛаборатория = "научная лаборатория"
//    case практическиеЗанятия = "практические занятия"
//    case рабочийКабинет = "рабочий кабинет"
//}
//
//// MARK: - BuildingNumber
//struct BuildingNumber: Codable {
//    let id: Int
//    let name: BuildingNumberName
//}
//
//enum BuildingNumberName: String, Codable {
//    case the1К = "1 к."
//    case the2К = "2 к."
//    case the3К = "3 к."
//    case the4К = "4 к."
//    case the5К = "5 к."
//    case the6К = "6 к."
//    case the7К = "7 к."
//    case the8К = "8 к."
//    case автохозяйство = "Автохозяйство"
//    case общежитие1 = "Общежитие №1"
//    case общежитие2 = "Общежитие №2"
//    case общежитие3 = "Общежитие №3"
//    case общежитие4 = "Общежитие №4"
//    case общежитиеМРК = "Общежитие МРК"
//    case спортивноОздоровительныйКомплексБраславскиеОзера = "Спортивно-оздоровительный комплекс «Браславские озера»"
//    case филиалМинскийРадиотехническийКолледж = "Филиал «Минский радиотехнический колледж»"
//}
//
//// MARK: - Department
//struct Department: Codable {
//    let idDepartment: Int
//    let abbrev, name, nameAndAbbrev: String
//}
//
//enum Note: String, Codable {
//    case empty = ""
//    case mM = "m/m"
//    case преподавательская = "преподавательская"
//}
//
//typealias Welcome = [WelcomeElement]
