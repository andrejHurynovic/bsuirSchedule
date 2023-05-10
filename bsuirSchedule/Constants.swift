//
//  Constants.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 5.05.23.
//

import SwiftUI

struct Constants {
    
    struct Colors {
        static let lecture = Color.green
        static let practice = Color.red
        static let laboratory = Color.blue
        static let consultation = Color.gray
        static let exam = Color.yellow
    }
    
    struct Symbols {
        static let auditorium = "mappin"
        static let configuration = "gear"
        static let department = "briefcase.fill"
        static let employee = "person.circle.fill"
        static let employees = "person.3.fill"
        static let group = "person.2.circle"
        static let lessonDates = "calendar.badge.clock"
        static let lessonDate = "calendar"
        static let lessonWeeks = "calendar.circle"
        static let schedule = "calendar"
    }
    
    struct Ranges {
        static let weeks = 0...3
        static let weekdays = 1...7
    }
    
    static let alphabet = ["А", "Б", "В", "Г", "Д", "Е", "Ё", "Ж", "З", "И", "Й", "К", "Л", "М", "Н", "О", "П", "Р", "С", "Т", "У", "Ф", "Х", "Ц", "Ч", "Ш", "Щ", "Ъ", "Ы", "Ь", "Э", "Ю", "Я"]
    
    static let relativeFormatDatesRange = -1...1
    static let todayCheckPublisherRange = relativeFormatDatesRange.lowerBound...5
    
}
