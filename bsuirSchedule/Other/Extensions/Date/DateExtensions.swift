//
//  DateExtensions.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 19.10.22.
//

import Foundation


extension Date {
    //MARK: - Time
    
    ///Returns Date with assigned hours, minutes and seconds values from another date.
    func assignedTime(from date: Date) -> Date {
        let dateComponents = Calendar.autoupdatingCurrent.dateComponents([.hour, .minute, .second], from: date)
        var date = Calendar.autoupdatingCurrent.date(bySetting: .hour, value: dateComponents.hour!, of: self)!
        date = Calendar.autoupdatingCurrent.date(bySetting: .minute, value: dateComponents.minute!, of: date)!
        date = Calendar.autoupdatingCurrent.date(bySetting: .second, value: dateComponents.second!, of: date)!
        return date
    }
    var time: Date {
        return DateComponents(calendar: .current, year: 2000, month: 1, day: 1).date!.assignedTime(from: self)
    }
    
    //MARK: - weekday
    
    var weekday: Int16 {
        Int16((Calendar(identifier: .iso8601).ordinality(of: .weekday, in: .weekOfYear, for: self)!))
    }
}

//MARK: - Ranges

///Returns stride of days.
func datesStride(_ dateA: Date?, _ dateB: Date?) -> [Date] {
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
