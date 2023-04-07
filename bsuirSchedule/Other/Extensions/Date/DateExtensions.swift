//
//  DateExtensions.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 19.10.22.
//

import Foundation

//MARK: - Operators
///Returns the date to which the components were added.
func +(left: Date, right: DateComponents) -> Date {
    return Calendar.current.date(byAdding: right, to: left)!
}

///Assigns the date to which the components were added.
func +=(left: inout Date, right: DateComponents) {
    left = Calendar.current.date(byAdding: right, to: left)!
}



//MARK: - Time

extension Date {
    ///Assigns hours, minutes and seconds  to Date from DateComponents.
    mutating func assignTime(_ dateComponents: DateComponents) {
        self = Calendar.current.date(bySetting: .hour, value: dateComponents.hour!, of: self)!
        self = Calendar.current.date(bySetting: .minute, value: dateComponents.minute!, of: self)!
        self = Calendar.current.date(bySetting: .second, value: dateComponents.second!, of: self)!
    }
    ///Returns Date with assigned hours, minutes and seconds values from DateComponents.
    func assignedTime(_ dateComponents: DateComponents) -> Date {
        var date = Calendar.current.date(bySetting: .hour, value: dateComponents.hour!, of: self)!
        date = Calendar.current.date(bySetting: .minute, value: dateComponents.minute!, of: date)!
        date = Calendar.current.date(bySetting: .second, value: dateComponents.second!, of: date)!
        return date
    }
    
    ///Assigns hours, minutes, and seconds to zero.
    var time: Date {
        return DateComponents(calendar: .current, year: 2000, month: 1, day: 1).date!.assignedTime(self.timeDateComponents)
    }
    
    ///DateComponents with hours, minutes and seconds from provided Date.
    var timeDateComponents: DateComponents {
        return Calendar.current.dateComponents([.hour, .minute, .second], from: self)
    }
    
    mutating func removeTime() {
        self = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }
    ///Returns Date with hours, minutes, seconds and nanoseconds assigned to zero.
    func removedTime() -> Date {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }
    
    func dateComponentsTo(_ anotherDate: Date, _ dateComponent: Calendar.Component) -> Int {
        return Calendar.current.dateComponents([dateComponent], from: self, to: anotherDate).value(for: dateComponent)!
    }
    
}

//MARK: - Ranges

///Returns stride of days.
func datesBetween(_ dateA: Date?, _ dateB: Date?) -> [Date] {
    guard let dateA = dateA, let dateB = dateB else {
        return []
    }
    
    let dayDurationInSeconds: TimeInterval = 60 * 60 * 24
    var dates: [Date] = []
    
    for date in stride(from: dateA, to: dateB, by: dayDurationInSeconds) {
        dates.append(date)
    }
    dates.append(dateB)
    return dates
    
}

extension ClosedRange where Bound == Date {
    func numberOfDaysBetween() -> Int {
        let calendar = Calendar.current
        
        let fromDate = calendar.startOfDay(for: self.lowerBound)
        let toDate = calendar.startOfDay(for: self.upperBound)
        let numberOfDays = calendar.dateComponents([.day], from: fromDate, to: toDate)
        
        return numberOfDays.day! + 1
    }
}
