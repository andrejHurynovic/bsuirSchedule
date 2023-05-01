//
//  DepartmentDecoder.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 1.04.23.
//
//

import CoreData

@objc(Department)
public class Department: NSManagedObject {
    
    lazy var formattedName: String = self.name ?? self.abbreviation

    required public convenience init(from decoder: Decoder) throws {
        guard let container = try? decoder.container(keyedBy: CodingKeys.self) else {
            throw DepartmentDecodingError.noKeys
        }
        self.init(context: decoder.userInfo[.managedObjectContext] as! NSManagedObjectContext)
        
        self.id = (try? container.decode(Int16.self, forKey: .id)) ?? (try? container.decode(Int16.self, forKey: .idInAuditoriumContainer))!
        self.name = try! container.decode(String.self, forKey: .name)
        self.abbreviation = formattedAbbreviationString(from: try! container.decode(String.self, forKey: .abbreviation))
        
        Log.info("Department \(self.abbreviation) (\(String(self.id))) has been created.")
    }
    
    convenience public init(from string: String, in context: NSManagedObjectContext) throws {
        self.init(entity: Department.entity(), insertInto: context)
        
        self.abbreviation = formattedAbbreviationString(from: string)
    }
    
    private func formattedAbbreviationString(from string: String) -> String {
        var string = string
        if let range = string.range(of: "Каф.") {
            string.removeSubrange(range)
        }
        
        return string.capitalizingFirstLetter()
    }
    
}

extension Department: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case idInAuditoriumContainer = "idDepartment"
        case name = "name"
        case abbreviation = "abbrev"
    }
}

