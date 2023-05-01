//
//  AuditoriumDecoder.swift
//  Auditorium
//
//  Created by Andrej Hurynovič on 25.09.21.
//
//

import CoreData

@objc(Auditorium)
public class Auditorium: NSManagedObject {
    
    required convenience public init(from decoder: Decoder) throws {
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        
        let buildingContainer = try! container.nestedContainer(keyedBy: BuildingCodingKeys.self, forKey: .building)
        let buildingString = try! buildingContainer.decode(String.self, forKey: .name)
        
        //This code does not allow the creation of Auditories in non-educational buildings. The description of the Algorithm is provided in decodeBuilding() method.
        guard let _ = Int16(buildingString.trimmingCharacters(in: CharacterSet.init([" ", "к", "."]))) else {
            Log.warning("Fetched non-educational building, (\((try? container.decode(String.self, forKey: .name)) ?? "No name")-\(buildingString)).")
            throw AuditoriumDecodingError.nonEducationalBuilding
        }
        
        self.init(context: decoder.userInfo[.managedObjectContext] as! NSManagedObjectContext)
        
        try self.update(from: decoder)
    }
    
    ///This function creates a new Auditorium object from a string in the format ["000-1 к.", "604-5 к.", "epam 104 к1-2 к."].
    convenience public init(from string: String, in context: NSManagedObjectContext) throws {
        self.init(entity: Auditorium.entity(), insertInto: context)
        
        //"604-5 к." -> "5 к.".
        let buildingString = String(string.suffix(4))
        //"604-5 к." -> "604".
        let nameString = String(string.dropLast(5))
        try decodeBuilding(string: buildingString)
        try decodeName(string: nameString)
        self.formattedName = formateName()
        
        Log.info("Auditorium \(string) is created from string.")
    }
    
}

//MARK: - Update
extension Auditorium: DecoderUpdatable {
    func update(from decoder: Decoder) throws {
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        
        //MARK: - Building container
        let buildingContainer = try! container.nestedContainer(keyedBy: BuildingCodingKeys.self, forKey: .building)
        let buildingString = try! buildingContainer.decode(String.self, forKey: .name)
        let nameString = try! container.decode(String.self, forKey: .name)
        
        try decodeBuilding(string: buildingString)
        try decodeName(string: nameString)
        self.formattedName = formateName()
        
        self.capacity = (try? container.decode(Int16.self, forKey: .capacity)) ?? 0
        self.note = try? container.decode(String.self, forKey: .note)
        self.type = try! container.decode(AuditoriumType.self, forKey: .type)
        self.department = try? container.decode(Department.self, forKey: .department)
        Log.info("Auditorium \(String(self.formattedName)) fetched.")
    }
    
    ///Decodes string to Int16 building number or, in the case of non-educational building, throws an error.
    ///
    ///Generally a string is ["1 к.", "2 к.", "3 к.", "4 к.", "5 к.", "6 к.", "7 к.", "8 к."], but in some cases it may be ["Общежитие №4", "Филиал «Минский радиотехнический колледж»"].
    ///In order not to create unnecessary Auditories, the " к." part is removed from a string, making string able to cast into Int16. If string is not casted to Int16, then building is non-educational.
    ///Building container have "id" field, however there is no pattern between an id and building number, the more universal solution is to use the "name" filed.
    private func decodeBuilding(string: String) throws {
        guard let building = Int16(string.trimmingCharacters(in: CharacterSet.init([" ", "к", "."]))) else {
            Log.warning("Non-educational building \(string).")
            throw AuditoriumDecodingError.nonEducationalBuilding
        }
        self.building = building
    }
    
    ///Decodes string to floor and name, checks if is auditorium is outside of university.
    ///
    ///Generally a string is ["000", "010", "019", "04", "05", "06", "07", "08", "1 - 2", "102"], but in some cases is may be ["epam 103 к1",, "epam 401-1", "ОАО \"Планар\""].
    private func decodeName(string: String) throws {
        //If the first character is not a digit, the Auditorium is located outside the university, in this case there is no need to specify floor number.
        //Example names: ["epam 103 к1",, "epam 401-1", "ОАО \"Планар\""].
        if string.first!.isNumber == false {
            self.name = string
            self.outsideUniversity = true
            return
        }
        //If the Auditorium is located at the university, the name is separated into the floor number (Int16) and the name (String).
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
            Log.warning("Can't create name for Auditorium \(string)")
            throw AuditoriumDecodingError.incorrectName(name: string)
        }
        
        //If number is less then 100 and first character is not "0", then these are Auditories with names such as ["34", "69"].
        //Floor is specified as 0. Name is specified as full string (with first character).
        //Example: "34" -> floor == 0, name == "34".
        if number < 100, string.first != "0" {
            self.floor = 0
            self.name = string
            return
        }
        
        //If number is greater then 100, then these are Auditories on higher floors with names such as [100, 234, 325].
        //First character of string is floor number, it is casted to Int16.
        let floor = Int16(String(string.first!))!
        //Name is assigned as string without first character (which represents floor).
        let name = String(string.dropFirst(1))
        self.floor = floor
        self.name = name
    }
    
    private func formateName() -> String {
        if self.outsideUniversity {
            return self.name
        }
        return "\(self.floor)\(self.name)-\(self.building)"
    }
    
}

extension Auditorium: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case note
        case capacity
        
        case building = "buildingNumber"
        case type = "auditoryType"
        case department = "department"
    }
    
    private enum BuildingCodingKeys: String, CodingKey {
        case name
    }
    private enum AuditoriumCodingKeys: String, CodingKey {
        case id
    }
}
