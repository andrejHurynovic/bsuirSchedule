//
//  LessonExtensions.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 1.05.23.
//

import CoreData

extension Lesson : Identifiable {
    func id(sectionID: String? = nil) -> String {
        return "\(sectionID ?? "")-\(abbreviation)-\(timeStart)-\(subgroup)-\(auditoriesNames)-\(String(describing: employeesIDs))"
    }
}

//MARK: - Filters

extension Sequence where Element == Lesson {
    func filtered(abbreviation: String) -> any Sequence<Lesson> {
        guard !abbreviation.isEmpty else { return self }
        return self.filter { $0.abbreviation.localizedStandardContains(abbreviation) }
    }
    
    func filtered(subgroup: Int?) -> any Sequence<Lesson> {
        guard let subgroup = subgroup else {
            return self
        }
        let allowedSubgroups: [Int16] = [0, Int16(subgroup)]
        return self.filter { allowedSubgroups.contains($0.subgroup)  }
    }
}

//MARK: - Date and time

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
    
    ///Date range in form timeStart to timeEnd
    var timeRange: ClosedRange<Date> {
        let dateFormatter = DateFormatters.shared.time
        return dateFormatter.date(from: timeStart)!...dateFormatter.date(from: timeEnd)!
    }
}

//MARK: - Others

extension Lesson {
    ///A string representation of the lesson's weeks.
    var weeksDescription: String? {
        guard self.weeks.isEmpty == false else { return nil }
        guard self.weeks.count != 1 else { return String(weeks.first! + 1) }
        
        var weeks = self.weeks.map { $0 + 1 }

        var subStrings: [String] = []
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
                subStrings.append(String(nearWeeks.first!))
            } else {
                subStrings.append("\(nearWeeks.first!)-\(nearWeeks.last!)")
            }
                
        } while(weeks.isEmpty == false)

       return subStrings.joined(separator: ", ")
    }
}
