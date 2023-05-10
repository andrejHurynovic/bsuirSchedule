//
//  DegreeDecoder.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 10.05.23.
//

import CoreData

@objc(Degree)
public class Degree: NSManagedObject {
    required convenience public init(from decoder: Decoder) throws {
        let container = (try? decoder.container(keyedBy: CodingKeys.self)
            .nestedContainer(keyedBy: CodingKeys.self, forKey: .employeeNestedContainer))
        ?? (try! decoder.container(keyedBy: CodingKeys.self))
        
        guard let degreeString = try? container.decode(String.self, forKey: .degree),
        degreeString.isEmpty == false else {
            throw URLError(.cannotDecodeRawData)
        }
        let context = decoder.userInfo[.managedObjectContext] as! NSManagedObjectContext
        self.init(context: context)
        
        Log.info("Degree \(self.abbreviation) is created.")
        try! self.update(from: decoder)
    }
    
    func update(from decoder: Decoder) throws {
        let container = (try? decoder.container(keyedBy: CodingKeys.self)
            .nestedContainer(keyedBy: CodingKeys.self, forKey: .employeeNestedContainer))
        ?? (try! decoder.container(keyedBy: CodingKeys.self))
        
        let degreeString = try! container.decode(String.self, forKey: .degree)
        if let degreeAbbreviationString = try? container.decode(String.self, forKey: .degreeAbbreviation),
           degreeAbbreviationString.isEmpty == false {
            self.name = degreeString
            self.abbreviation = degreeAbbreviationString
        } else {
            self.abbreviation = degreeString
        }
        
        Log.info("Degree \(self.abbreviation) is updated.")
    }
}

extension Degree: Decodable {
    private enum CodingKeys: String, CodingKey {
        case degree = "degree"
        case degreeAbbreviation = "degreeAbbrev"
        
        case employeeNestedContainer = "employeeDto"
    }
}
