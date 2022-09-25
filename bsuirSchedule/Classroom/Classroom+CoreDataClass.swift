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
public class Classroom: NSManagedObject {
    
    convenience public init(string: String) {
        let context = PersistenceController.shared.container.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Classroom", in: context)
        self.init(entity: entity!, insertInto: context)
        
        self.originalName = string
        
        var string = string
        string.removeLast(3)
        self.building = Int16(String(string.removeLast()))!
        
        string.removeLast()
        
        var name = string
        
        if name.first!.isNumber == false {
            self.name = name
            self.outsideUniversity = true
        } else {
            
            var numberString = name.trimmingCharacters(in: .letters)
            if numberString.count > 3 {
                numberString.removeLast(numberString.count - 3)
                print(name)
            }
            guard let number = Int(numberString.trimmingCharacters(in: .letters)) else {
                self.originalName = "error"
                return
                //                throw ClassroomError.incorrectName
            }
            if number < 100 {
                //Ground floor
                //"04", "04а" -> "4а"
                if name.first == "0" {
                    name.removeFirst()
                }
                self.floor = 0
                self.name = name
            } else {
                //"314", "314a"
                self.floor = Int16(name.removeFirst().wholeNumberValue!)
                self.name = name
            }
        }
    }
    
    required convenience public init(from decoder: Decoder) throws {
        let context = PersistenceController.shared.container.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Classroom", in: context)
        self.init(entity: entity!, insertInto: context)
        
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        
        //MARK: Building
        let buildingContainer = try! container.nestedContainer(keyedBy: BuildingCodingKeys.self, forKey: .buildingContainer)
        let buildingString = try! buildingContainer.decode(String.self, forKey: .name)
        //Check for educational building
        guard let building = Int16(buildingString.trimmingCharacters(in: CharacterSet.init([" ", "к", "."]))) else {
            #warning("Придумать другое решение")
            self.originalName = "error"
            return
        }
        self.building = building
        
        //Name and floor
        var name = try! container.decode(String.self, forKey: .name)
        
        //Нужен для быстрого нахождения кабинета или для constraints
        self.originalName = "\(name)-\(buildingString)"

        //"Транзистор", "epam-104", "Столовая"
        if name.first!.isNumber == false {
            self.name = name
            self.outsideUniversity = true
        } else {
            
            var numberString = name.trimmingCharacters(in: .letters)
            if numberString.count > 3 {
                numberString.removeLast(numberString.count - 3)
                print(name)
            }
            guard let number = Int(numberString.trimmingCharacters(in: .letters)) else {
                self.originalName = "error"
                return
                //                throw ClassroomError.incorrectName
            }
            if number < 100 {
                //Ground floor
                //"04", "04а" -> "4а"
                if name.first == "0" {
                    name.removeFirst()
                }
                self.floor = 0
                self.name = name
            } else {
                //"314", "314a"
                self.floor = Int16(name.removeFirst().wholeNumberValue!)
                self.name = name
            }
        }
        
        
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
        if outsideUniversity == true {
            //outside university buildings
            //"Транзистор", "epam-104", "Столовая"
            return self.name
        } else {
            if showBuilding {
                //321-4
                return String(self.floor) + self.name + "-" + String(self.building)
            } else {
                //321
                return String(self.floor) + self.name
            }
        }
    }
    
    var groups: [Group] {
        let lessons = lessons?.allObjects as! [Lesson]
        let groups = Array(lessons.compactMap {($0.groups?.allObjects as! [Group])}.joined())
        return Set(groups).sorted { $0.id < $1.id }
    }
 
}

extension Classroom: Decodable {
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
