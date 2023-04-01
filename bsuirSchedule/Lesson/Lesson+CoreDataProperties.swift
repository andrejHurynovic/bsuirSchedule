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
    
    @NSManaged public var subject: String?
    @NSManaged public var abbreviation: String!
    @NSManaged public var lessonTypeValue: Int16
    @NSManaged public var note: String?
    
    
    @NSManaged public var dateString: String!
    @NSManaged public var weekday: Int16
    @NSManaged public var weeks: [Int]!
    @NSManaged public var startLessonDate: Date?
    @NSManaged public var startLessonDateString: String!
    @NSManaged public var endLessonDate: Date?
    @NSManaged public var timeStart: String!
    @NSManaged public var timeEnd: String!
    
    
    @NSManaged public var groups: NSSet?
    @NSManaged public var subgroup: Int16
    @NSManaged public var auditoriums:  NSSet?
    @NSManaged public var auditoriumsNames: [String]!
    @NSManaged public var employees: NSSet?
    @NSManaged public var employeesIDs: [Int32]!
    
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
    
    @objc(addAuditoriumsObject:)
    @NSManaged public func addToAuditoriums(_ value: Auditorium)

    @objc(removeAuditoriumsObject:)
    @NSManaged public func removeFromAuditoriums(_ value: Auditorium)

    @objc(addAuditoriums:)
    @NSManaged public func addToAuditoriums(_ values: NSSet)

    @objc(removeAuditoriums:)
    @NSManaged public func removeFromAuditoriums(_ values: NSSet)
}

extension Lesson : Identifiable {
    func id(sectionID: String? = nil) -> String {
        return "\(sectionID ?? "")-\(abbreviation!)-\(timeStart!)-\(subgroup)-\(auditoriumsNames ?? [])-\(String(describing: employeesIDs))"
    }
}

//MARK: Dates
extension Lesson {
    ///Converts dateString to Date type
    var date: Date? {
        guard dateString.isEmpty == false,
              let date = DateFormatters.shared.get(.shortDate).date(from: self.dateString) else {
            return nil
        }
        return date
    }
    ///Range between start and end date
    var dateRange: ClosedRange<Date>? {
        if let startLessonDate = self.startLessonDate, let endLessonDate = self.endLessonDate {
            return startLessonDate...endLessonDate
        } else {
            return nil
        }
    }
    
}

extension Array where Element == Lesson {
    mutating func filter(abbreviation: String) {
        guard !abbreviation.isEmpty else {
            return
        }
        self.removeAll { $0.abbreviation.localizedStandardContains(abbreviation) == false }
    }
    
    mutating func filter(subgroup: Int?) {
        guard let subgroup = subgroup else {
            return
        }
        let allowedSubgroups: [Int16] = [0, Int16(subgroup)]
        self.removeAll { allowedSubgroups.contains($0.subgroup) == false }
    }
}

//MARK: Time

extension Lesson {
    ///Date range in form timeStart to timeEnd
    var timeRange: ClosedRange<Date> {
        let dateFormatter = DateFormatters.shared.time
        return dateFormatter.date(from: timeStart)!...dateFormatter.date(from: timeEnd)!
    }
    
}

//MARK: Others
extension Lesson {
    var weeksDescription: String? {
        guard self.weeks.isEmpty == false else {
            return nil
        }
        
        if weeks.count == 1 {
            return String(weeks.first! + 1)
        }
        
        var weeks = self.weeks.map {$0 + 1}

        var resultWeeks: [String] = []
        var nearWeeks: [Int] = []

        repeat {
            nearWeeks.removeAll()
            nearWeeks.append(weeks.removeFirst())
            
            while(weeks.isEmpty == false) {
                if nearWeeks.last! + 1 == weeks.first {
                    nearWeeks.append(weeks.removeFirst())
                } else {
                    break
                }
            }
            
            if nearWeeks.count == 1 {
                resultWeeks.append(String(nearWeeks.first!))
            } else {
                resultWeeks.append("\(nearWeeks.first!)-\(nearWeeks.last!)")
            }
                
        } while(weeks.isEmpty == false)

       return resultWeeks.joined(separator: ", ")

    }
}
