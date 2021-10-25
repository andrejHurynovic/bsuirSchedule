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
        
        self.subject = ((try? container.decode(String.self, forKey: .subject)) ?? "")
        switch (try? container.decode(String.self, forKey: .lessonTypeValue)) {
        case nil:
            self.lessonType = .none
        case "ЛК":
            self.lessonType = .lecture
        case "УЛк":
            self.lessonType = .remoteLecture
        case "ПЗ":
            self.lessonType = .practice
        case "УПз":
            self.lessonType = .remotePractice
        case "ЛР":
            self.lessonType = .laboratory
        case "Экзамен":
            self.lessonType = .exam
        case "Консультация":
            self.lessonType = .consultation
        case "Кандидатский зачет":
            self.lessonType = .candidateText
        default:
            self.lessonType = .none
            break
        }
        if let classrooms = try? container.decode([String].self, forKey: .classroom) {
            classrooms.forEach { classroomName in
                if let classroom = ClassroomStorage.shared.classroom(name: classroomName) {
                    self.addToClassrooms(classroom)
                }
            }
        }
        self.note = try? container.decode(String.self, forKey: .note)
        
        (try! container.decode([String].self, forKey: .groups)).forEach { groupID in
            if let group = GroupStorage.shared.values.value.first(where: {$0.id == groupID}) {
                self.addToGroups(group)
            }
        }
        self.subgroup = Int16(try! container.decode(Int.self, forKey: .subgroup))
        
        self.weeks = try! container.decode([Int].self, forKey: .weeks)
        self.timeStart = try! container.decode(String.self, forKey: .timeStart)
        self.timeEnd = try! container.decode(String.self, forKey: .timeEnd)
        
        let employees: [[String: Any]] = try container.decode(Array<Any>.self, forKey: .employee) as! [[String: Any]]
        
        self.employeesIDs = employees.map {$0["id"] as! Int}
        
        employeesIDs?.forEach(body: { employeeID in
            self.addToEmployees(EmployeeStorage.shared.values.value.first(where: {
                $0.id == employeeID
            })!)
        })
    }
    
    
    func getLessonTypeAbbreviation() -> String {
        switch self.lessonType {
        case .none:
            return "Без типа"
        case .lecture:
            return "ЛК"
        case .remoteLecture:
            return "УЛК"
        case .practice:
            return "ПЗ"
        case .remotePractice:
            return "УПЗ"
        case .laboratory:
            return "ЛР"
        case .consultation:
            return "Конс"
        case .exam:
            return "Экз"
        case .candidateText:
            return "КЗ"
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case subject = "subject"
        case lessonTypeValue = "lessonType"
        case classroom = "auditory"
        case note = "note"
        
        case groups = "studentGroup"
        case subgroup = "numSubgroup"
        
        case weeks = "weekNumber"
        case timeStart = "startLessonTime"
        case timeEnd = "endLessonTime"
        
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
