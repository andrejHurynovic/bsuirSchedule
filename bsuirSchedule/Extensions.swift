//
//  Extensions.swift
//  Extensions
//
//  Created by Andrej Hurynovič on 9.09.21.
//

import Foundation
import SwiftUI
import UIKit

//MARK: Array

extension Array {
    mutating func forEachInout(body: (inout Element) throws -> Void) rethrows {
        for index in self.indices {
            try body(&self[index])
        }
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
    
    mutating func setTime(_ time: Date) {
        let dateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: time)
        self = Calendar.current.date(bySettingHour: dateComponents.hour!, minute: dateComponents.minute!, second: dateComponents.second!, of: self)!
    }
    
    func withTime(_ time: Date) -> Date {
        let dateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: time)
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

    func time() -> Date {
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


struct ViewDidLoadModifier: ViewModifier {
    
    @State private var didLoad = false
    private let action: (() -> Void)?
    
    init(perform action: (() -> Void)? = nil) {
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content.onAppear {
            if didLoad == false {
                didLoad = true
                action?()
            }
        }
    }
    
}

extension View {
    
    func onLoad(perform action: (() -> Void)? = nil) -> some View {
        modifier(ViewDidLoadModifier(perform: action))
    }
    
}


extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
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
