//
//  Lesson+CoreDataProperties.swift
//  Lesson
//
//  Created by Andrej Hurynovič on 6.09.21.
//
//

import Foundation
import CoreData



extension Lesson {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Lesson> {
        let request = NSFetchRequest<Lesson>(entityName: "Lesson")
        request.sortDescriptors = []
        return request
    }
    
    @NSManaged public var subject: String!
    @NSManaged public var lessonTypeValue: Int16
    @NSManaged public var classrooms:  NSSet?
    @NSManaged public var note: String?
    
    @NSManaged public var groups: NSSet?
    @NSManaged public var subgroup: Int16
    
    @NSManaged public var weekday: Int16
    @NSManaged public var weeks: [Int]!
    @NSManaged public var dateString: String!
    
    @NSManaged public var timeStart: String!
    @NSManaged public var timeEnd: String!
    
    @NSManaged public var employees: NSSet?
    @NSManaged public var employeesIDs: [Int]?
    
}

// MARK: Generated accessors for groups
extension Lesson {

    @objc(addGroupsObject:)
    @NSManaged public func addToGroups(_ value: Group)

    @objc(removeGroupsObject:)
    @NSManaged public func removeFromGroups(_ value: Group)

    @objc(addGroups:)
    @NSManaged public func addToGroups(_ values: NSSet)

    @objc(removeGroups:)
    @NSManaged public func removeFromGroups(_ values: NSSet)
    
    @objc(addEmployeesObject:)
    @NSManaged public func addToEmployees(_ value: Employee)

    @objc(removeEmployeesObject:)
    @NSManaged public func removeFromEmployees(_ value: Employee)

    @objc(addEmployees:)
    @NSManaged public func addToEmployees(_ values: NSSet)

    @objc(removeEmployees:)
    @NSManaged public func removeFromEmployees(_ values: NSSet)
    
    @objc(addClassroomsObject:)
    @NSManaged public func addToClassrooms(_ value: Classroom)

    @objc(removeClassroomsObject:)
    @NSManaged public func removeFromClassrooms(_ value: Classroom)

    @objc(addClassrooms:)
    @NSManaged public func addToClassrooms(_ values: NSSet)

    @objc(removeClassrooms:)
    @NSManaged public func removeFromClassrooms(_ values: NSSet)
}

extension Lesson : Identifiable {
    var lessonType: LessonType {
        get {
            return LessonType(rawValue: self.lessonTypeValue)!
        }
        set {
            self.lessonTypeValue = newValue.rawValue
        }
    }
    
    var date: Date? {
        guard dateString.isEmpty == false else {
            return nil
        }
        return DateFormatters.shared.dateFormatterddMMyyyy.date(from: self.dateString)!
    }
}

enum LessonType: Int16, CaseIterable {
    case none = 0
    case lecture = 1
    case remoteLecture = 2
    case practice = 3
    case remotePractice = 4
    case laboratory = 5
    case consultation = 6
    case exam = 7
    case candidateText = 8
    
    func description() -> String {
        switch self {
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
}

enum WeekDay: Int16, CaseIterable, Decodable {
    case Monday = 0
    case Tuesday = 1
    case Wednesday = 2
    case Thursday = 3
    case Friday = 4
    case Saturday = 5
    case Sunday = 6
}

extension Date {
    func weekDay() -> WeekDay {
        WeekDay(rawValue: Int16((Calendar(identifier: .iso8601).ordinality(of: .weekday, in: .weekOfYear, for: self)! - 1)))!
    }
}
