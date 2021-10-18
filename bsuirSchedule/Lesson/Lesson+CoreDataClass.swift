//
//  Lesson+CoreDataClass.swift
//  Lesson
//
//  Created by Andrej Hurynovič on 6.09.21.
//
//

import Foundation
import CoreData
import SwiftUI


@objc(Lesson)
public class Lesson: NSManagedObject, Decodable {
    
    required convenience public init(from decoder: Decoder) throws {
        let context = PersistenceController.shared.container.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Lesson", in: context)
        self.init(entity: entity!, insertInto: context)
        
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        
        self.subgroup = Int16(try! container.decode(Int.self, forKey: .subgroup))
        self.subject = try! container.decode(String.self, forKey: .subject)
        self.timeStart = try! container.decode(String.self, forKey: .timeStart)
        self.timeEnd = try! container.decode(String.self, forKey: .timeEnd)
        self.weekNumber = try! container.decode([Int].self, forKey: .weekNumber)
        let groupsString = try! container.decode([String].self, forKey: .groups)
        groupsString.forEach { groupID in
            self.addToGroups(GroupStorage.shared.values.value.first(where: {$0.id == groupID})!)
        }
        
        
        switch (try! container.decode(String.self, forKey: .lessonTypeValue)) {
        case "ЛК":
            self.lessonType = .lecture
        case "ПЗ":
            self.lessonType = .practice
        case "ЛР":
            self.lessonType = .laboratory
        default: break
            
        }
        
        if let audiences = try? container.decode([String].self, forKey: .classroom) {
            if audiences.isEmpty == false {
                self.classroom = ClassroomStorage.shared.classroom(name: audiences.first!)
            }
        }
        
        let items: [[String: Any]] = try container.decode(Array<Any>.self, forKey: .employee) as! [[String: Any]]
        
        if !items.isEmpty {
            self.employeeID = Int32(items.first!["id"] as! Int)
        }
    }
    
    func getColor() -> Color {
        switch self.lessonType {
        case .lecture:
            return Color(UserDefaults.standard.color(forKey: "lectureColor") ?? .green)
        case .practice:
            return Color(UserDefaults.standard.color(forKey: "practiceColor") ?? .yellow)
        case .laboratory:
            return Color(UserDefaults.standard.color(forKey: "labWorkColor") ?? .red)
        }
    }
    
    func getLessonTypeAbbreviation() -> String {
        switch self.lessonType {
        case .lecture:
            return "ЛК"
        case .practice:
            return "ПЗ"
        case .laboratory:
            return "ЛР"
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case classroom = "auditory"
        case groups = "studentGroup"
        case lessonTypeValue = "lessonType"
        case subgroup = "numSubgroup"
        case subject = "subject"
        case timeEnd = "endLessonTime"
        case timeStart = "startLessonTime"
        case weekNumber = "weekNumber"
        case employee = "employee"
    }
}
struct JSONCodingKeys: CodingKey {
    var stringValue: String
    
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    
    var intValue: Int?
    
    init?(intValue: Int) {
        self.init(stringValue: "\(intValue)")
        self.intValue = intValue
    }
}


extension KeyedDecodingContainer {
    
    func decode(_ type: Dictionary<String, Any>.Type, forKey key: K) throws -> Dictionary<String, Any> {
        let container = try self.nestedContainer(keyedBy: JSONCodingKeys.self, forKey: key)
        return try container.decode(type)
    }
    
    func decodeIfPresent(_ type: Dictionary<String, Any>.Type, forKey key: K) throws -> Dictionary<String, Any>? {
        guard contains(key) else {
            return nil
        }
        guard try decodeNil(forKey: key) == false else {
            return nil
        }
        return try decode(type, forKey: key)
    }
    
    func decode(_ type: Array<Any>.Type, forKey key: K) throws -> Array<Any> {
        var container = try self.nestedUnkeyedContainer(forKey: key)
        return try container.decode(type)
    }
    
    func decodeIfPresent(_ type: Array<Any>.Type, forKey key: K) throws -> Array<Any>? {
        guard contains(key) else {
            return nil
        }
        guard try decodeNil(forKey: key) == false else {
            return nil
        }
        return try decode(type, forKey: key)
    }
    
    func decode(_ type: Dictionary<String, Any>.Type) throws -> Dictionary<String, Any> {
        var dictionary = Dictionary<String, Any>()
        
        for key in allKeys {
            if let boolValue = try? decode(Bool.self, forKey: key) {
                dictionary[key.stringValue] = boolValue
            } else if let stringValue = try? decode(String.self, forKey: key) {
                dictionary[key.stringValue] = stringValue
            } else if let intValue = try? decode(Int.self, forKey: key) {
                dictionary[key.stringValue] = intValue
            } else if let doubleValue = try? decode(Double.self, forKey: key) {
                dictionary[key.stringValue] = doubleValue
            } else if let nestedDictionary = try? decode(Dictionary<String, Any>.self, forKey: key) {
                dictionary[key.stringValue] = nestedDictionary
            } else if let nestedArray = try? decode(Array<Any>.self, forKey: key) {
                dictionary[key.stringValue] = nestedArray
            }
        }
        return dictionary
    }
}

extension UnkeyedDecodingContainer {
    
    mutating func decode(_ type: Array<Any>.Type) throws -> Array<Any> {
        var array: [Any] = []
        while isAtEnd == false {
            // See if the current value in the JSON array is `null` first and prevent infite recursion with nested arrays.
            if try decodeNil() {
                continue
            } else if let value = try? decode(Bool.self) {
                array.append(value)
            } else if let value = try? decode(Double.self) {
                array.append(value)
            } else if let value = try? decode(String.self) {
                array.append(value)
            } else if let nestedDictionary = try? decode(Dictionary<String, Any>.self) {
                array.append(nestedDictionary)
            } else if let nestedArray = try? decode(Array<Any>.self) {
                array.append(nestedArray)
            }
        }
        return array
    }
    
    mutating func decode(_ type: Dictionary<String, Any>.Type) throws -> Dictionary<String, Any> {
        
        let nestedContainer = try self.nestedContainer(keyedBy: JSONCodingKeys.self)
        return try nestedContainer.decode(type)
    }
}
