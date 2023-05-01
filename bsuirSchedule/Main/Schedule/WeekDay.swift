//
//  WeekDay.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 25.09.22.
//

import Foundation

enum WeekDay: Int16, CaseIterable, Decodable {
    init(string: String) {
        switch(string) {
        case "Понедельник":
            self = .Monday
        case "Вторник":
            self = .Tuesday
        case "Среда":
            self = .Wednesday
        case "Четверг":
            self = .Thursday
        case "Пятница":
            self = .Friday
        case "Суббота":
            self = .Saturday
        case "Воскресенье":
            self = .Sunday
        default:
            self = .none
        }
    }
    
    var description: String {
        switch(self) {
        case .Monday:
            return "Понедельник"
        case .Tuesday:
            return "Вторник"
        case .Wednesday:
            return "Среда"
        case .Thursday:
            return "Четверг"
        case .Friday:
            return "Пятница"
        case .Saturday:
            return "Суббота"
        case .Sunday:
            return "Воскресенье"
        default:
            return ""
        }
    }
    
    case Monday = 0
    case Tuesday = 1
    case Wednesday = 2
    case Thursday = 3
    case Friday = 4
    case Saturday = 5
    case Sunday = 6
    case none = 7
}

extension Date {
    func weekDay() -> WeekDay {
        WeekDay(rawValue: Int16((Calendar(identifier: .iso8601).ordinality(of: .weekday, in: .weekOfYear, for: self)! - 1)))!
    }
}
