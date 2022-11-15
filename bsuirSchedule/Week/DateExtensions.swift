//
//  DateExtensions.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 19.10.22.
//

import Foundation

extension Date {
    mutating func addDay() {
        var dayComponent = DateComponents()
        dayComponent.day = 1
        let theCalendar = Calendar.current
        self = theCalendar.date(byAdding: dayComponent, to: self)!
        
    }
    
    mutating func setTime(_ time: Date) {
        let dateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: time)
        self = Calendar.current.date(bySettingHour: dateComponents.hour!, minute: dateComponents.minute!, second: dateComponents.second!, of: self)!
    }
    
    func withTime(_ timeSourceDate: Date) -> Date {
        let dateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: timeSourceDate)
        return Calendar.current.date(bySettingHour: dateComponents.hour!, minute: dateComponents.minute!, second: dateComponents.second!, of: self)!
    }
    
    func minutesTo(_ endTime: Date) -> Int {
        return Int(Calendar.current.dateComponents([.minute], from: self, to: endTime).minute!)
    }
    
    func relativelyNow() -> ComparisonResult {
        return self.compare(Date())
    }
    func plus(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }

    var time: Date {
        return DateFormatters.shared.get(.shortDate).date(from: "01.01.2000")!.withTime(self)
    }
    
}

//Возвращает все дни из промежутка с одним и тем же временем.
func datesBetween(_ dateA: Date?, _ dateB: Date?) -> [Date] {
    if let dateA = dateA, let dateB = dateB {
        let dayDurationInSeconds: TimeInterval = 60 * 60 * 24
        var dates: [Date] = []
        
        for date in stride(from: dateA, to: dateB, by: dayDurationInSeconds) {
            dates.append(date)
        }
        dates.append(dateB)
        return dates
    } else {
        return []
    }
}

extension Date {
    func minutesFromMidnight() -> Int {
        let dateComponents = Calendar.current.dateComponents([.minute, .hour], from: self)
        
        return dateComponents.hour! * 60 + dateComponents.minute!
    }
}


extension ClosedRange where Bound == Date {
    func compare(date: Date) -> ComparisonResult {
        if self.lowerBound.minutesFromMidnight() > date.minutesFromMidnight() {
            return ComparisonResult.orderedAscending
        }
        if self.upperBound.minutesFromMidnight() < date.minutesFromMidnight() {
            return ComparisonResult.orderedDescending
        }
        return ComparisonResult.orderedSame
    }
    func numberOfDaysBetween() -> Int {
        let calendar = Calendar.current
        
        let fromDate = calendar.startOfDay(for: self.lowerBound) // <1>
        let toDate = calendar.startOfDay(for: self.upperBound) // <2>
        let numberOfDays = calendar.dateComponents([.day], from: fromDate, to: toDate) // <3>
        
        return numberOfDays.day! + 1
    }
}
