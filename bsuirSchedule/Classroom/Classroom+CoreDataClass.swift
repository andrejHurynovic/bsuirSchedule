//
//  Classroom+CoreDataClass.swift
//  Classroom
//
//  Created by Andrej Hurynovič on 25.09.21.
//
//

import CoreData

enum ClassroomError: Error {
    case incorrectName(name: String)
    case nonEducationalBuilding
}

@objc(Classroom)
public class Classroom: NSManagedObject {
    
    required convenience public init(from decoder: Decoder) throws {
        let container = try! decoder.container(keyedBy: CodingKeys.self)

        //MARK: Building container
        let buildingContainer = try! container.nestedContainer(keyedBy: BuildingCodingKeys.self, forKey: .buildingContainer)
        let buildingString = try! buildingContainer.decode(String.self, forKey: .name)
        
        guard let _ = Int16(buildingString.trimmingCharacters(in: CharacterSet.init([" ", "к", "."]))) else {
            throw ClassroomError.nonEducationalBuilding
        }
        
        let context = PersistenceController.shared.container.viewContext
        self.init(entity: Classroom.entity(), insertInto: context)
        
        do {
            try self.update(from: decoder)
        } catch {
            throw error
        }
    }
    
    convenience public init(string: String, context: NSManagedObjectContext) throws {
        let entity = Classroom.entity()
        self.init(entity: entity, insertInto: context)
        
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
                throw ClassroomError.incorrectName(name: self.originalName)
            }
            if number < 100 {
                //Ground floor: "04", "04а" -> "4а"
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
    
}

//MARK: Update
extension Classroom: DecoderUpdatable {
    func update(from decoder: Decoder) throws {
        let container = try! decoder.container(keyedBy: CodingKeys.self)
                
        //MARK: Building container
        let buildingContainer = try! container.nestedContainer(keyedBy: BuildingCodingKeys.self, forKey: .buildingContainer)
        let buildingString = try! buildingContainer.decode(String.self, forKey: .name)
        
        guard let building = Int16(buildingString.trimmingCharacters(in: CharacterSet.init([" ", "к", "."]))) else {
            throw ClassroomError.nonEducationalBuilding
        }
        self.building = building
        
        //MARK: Name and floor
        var name = try! container.decode(String.self, forKey: .name)
        
        //For constraints and fast search
        self.originalName = "\(name)-\(buildingString)"
        
        //"Транзистор", "epam-104", "Столовая"
        if name.first!.isNumber == false {
            self.name = name
            self.outsideUniversity = true
        } else {
            
            let numberString = name.prefix(3)
            guard let number = Int(numberString) else {
                throw ClassroomError.incorrectName(name: self.originalName)
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
        
        //MARK: Classroom container
        let classroomContainer = try? container.nestedContainer(keyedBy: ClassroomCodingKeys.self, forKey: .typeContainer)
        self.typeValue = try! classroomContainer!.decode(Int16.self, forKey: .id)
        
        
        if let nestedContainer = try? container.nestedContainer(keyedBy: DepartmentCodingKeys.self, forKey: .departmentContainer) {
            self.departmentName = try! nestedContainer.decode(String.self, forKey: .departmentName)
            
            var departmentAbbreviation = try! nestedContainer.decode(String.self, forKey: .departmentAbbreviation)
            if let range = departmentAbbreviation.range(of: "каф.") {
                departmentAbbreviation.removeSubrange(range)
            }
            if let range = departmentAbbreviation.range(of: "Каф.") {
                departmentAbbreviation.removeSubrange(range)
            }
            self.departmentAbbreviation = departmentAbbreviation.trimmingCharacters(in: .whitespaces)
        }
    }
    
}

extension Classroom: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
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
