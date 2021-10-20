//
//  Extensions.swift
//  Extensions
//
//  Created by Andrej Hurynovič on 9.09.21.
//

import UIKit

//MARK: Array

extension Array {
    mutating func forEach(body: (inout Element) throws -> Void) rethrows {
        for index in self.indices {
            try body(&self[index])
        }
    }
}

extension Array where Element == Lesson {
    func forWeekNumber(_ weekNumber: Int) -> [Lesson] {
        self.filter{$0.weeks!.contains(where: {$0 == weekNumber})}
    }
    func forWeekDay(_ weekDay: Int) -> [Lesson] {
        self.filter{$0.weekDay.rawValue == weekDay}.sorted(by: {$0.timeStart! < $1.timeStart!})
    }
}

//MARK: Date

extension Date {
    mutating func addDay() {
        var dayComponent = DateComponents()
        dayComponent.day = 1 // For removing one day (yesterday): -1
        let theCalendar = Calendar.current
        self = theCalendar.date(byAdding: dayComponent, to: self)!
        
    }
}

extension Date: Strideable {
    public func distance(to other: Date) -> TimeInterval {
        return other.timeIntervalSinceReferenceDate - self.timeIntervalSinceReferenceDate
    }

    public func advanced(by n: TimeInterval) -> Date {
        return self + n
    }
}

func weeksBetween(start: Date, end: Date) -> Int {
    let calendar = Calendar(identifier: .iso8601)
    return calendar.dateComponents([.weekOfYear], from: end).weekOfYear! - calendar.dateComponents([.weekOfYear], from: start).weekOfYear!
}

//MARK: UserDefaults

extension UserDefaults {
    func color(forKey key: String) -> UIColor? {

        guard let colorData = data(forKey: key) else { return nil }

        do {
            return try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData)
        } catch let error {
            print("color error \(error.localizedDescription)")
            return nil
        }

    }

    func set(_ value: UIColor?, forKey key: String) {

        guard let color = value else { return }
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
            set(data, forKey: key)
        } catch let error {
            print("error color key data not saved \(error.localizedDescription)")
        }
    }
}
