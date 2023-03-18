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
            Log.warning("Fetched non-educational building, (\((try? container.decode(String.self, forKey: .name)) ?? "No name")-\(buildingString)).")
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
        Log.warning("Can't find classroom \(string)")
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
        let startTime = CFAbsoluteTimeGetCurrent()
                
        //MARK: Building container
        let buildingContainer = try! container.nestedContainer(keyedBy: BuildingCodingKeys.self, forKey: .buildingContainer)
        let buildingString = try! buildingContainer.decode(String.self, forKey: .name)
        let nameString = try! container.decode(String.self, forKey: .name)
        self.originalName = "\(nameString)-\(buildingString)"
        
        try decodeBuilding(string: buildingString)
        try decodeName(string: nameString)
        
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
        Log.info("Classroom \(String(self.formattedName(showBuilding: true))) fetched, time: \((CFAbsoluteTimeGetCurrent() - startTime).roundTo(places: 3)) seconds")
    }
    
    ///Decodes string to Int16 building number or, in the case of non-educational building, throws an error.
    ///
    ///Generally a string is ["1 к.", "2 к.", "3 к.", "4 к.", "5 к.", "6 к.", "7 к.", "8 к."], but in some cases it may be ["Общежитие №4", "Филиал «Минский радиотехнический колледж»"].
    ///In order not to create unnecessary Classrooms, the " к." part is removed from a string, making string able to cast into Int16. If string is not casted to Int16, then building is non-educational.
    ///Building container have "id" field, however there is no pattern between an id and building number, the more universal solution is to use the "name" filed.
    private func decodeBuilding(string: String) throws {
        guard let building = Int16(string.trimmingCharacters(in: CharacterSet.init([" ", "к", "."]))) else {
            Log.warning("Non-educational building \(string)")
            throw ClassroomError.nonEducationalBuilding
        }
        self.building = building
    }
    
    ///Decodes string to floor and name, checks if is classroom is outside of university.
    ///
    ///Generally a string is ["000", "010", "019", "04", "05", "06", "07", "08", "1 - 2", "102"], but in some cases is may be ["epam 103 к1",, "epam 401-1", "ОАО \"Планар\""].
    private func decodeName(string: String) throws {
        //If the first character is not a digit, the Classroom is located outside the university, in this case there is no need to specify floor number.
        //Example names: ["epam 103 к1",, "epam 401-1", "ОАО \"Планар\""].
        if string.first!.isNumber == false {
            self.name = string
            self.outsideUniversity = true
            return
        }
        //If the Classroom is located at the university, the name is separated into the floor number (Int16) and the name (String).
        //Example:
        //"000"     -> floor == 0, name == "00";
        //"04"      -> floor == 0, name == "04";
        //"04а"     -> floor == 0, name == "04а";
        //"39"      -> floor == 0, name == "39";
        //"111(3)"  -> floor == 1, name == "11(3)";
        //"213б"    -> floor == 2, name == "13б";
        //"302-1"   -> floor == 3, name == "02-1".
        
        //
        guard let number = Int(string.prefix(3)) ?? Int(string.prefix(2)) else {
            Log.warning("Can't create name for Classroom \(string)-\(building)")
            throw ClassroomError.incorrectName(name: string)
        }
        
        //If number is less then 100 and first character is not "0", then these are Classrooms with names such as ["34", "69"].
        //Floor is specified as 0. Name is specified as full string (with first character).
        //Example: "34" -> floor == 0, name == "34".
        if number < 100, string.first != "0" {
            self.floor = 0
            self.name = string
            return
        }
        
        //If number is greater then 100, then these are Classrooms on higher floors with names such as [100, 234, 325].
        //First character of string is floor number, it is casted to Int16.
        self.floor = Int16(String(string.first!))!
        //Name is assigned as string without first character (which represents floor).
        self.name = String(string.dropFirst(1))
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

//MARK: CodingUserInfoKey
extension CodingUserInfoKey {
    static let classrooms = CodingUserInfoKey(rawValue: "classrooms")!
}

