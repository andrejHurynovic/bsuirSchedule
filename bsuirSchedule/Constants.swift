//
//  Constants.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 5.05.23.
//

import SwiftUI
import Combine

struct Constants {
    
    struct Colors {
        static let background = Color(UIColor.systemGroupedBackground)
        static let element = Color(UIColor.secondarySystemGroupedBackground)
        
        static let lecture = Color.green
        static let practice = Color.red
        static let laboratory = Color.blue
        static let consultation = Color.indigo
        static let exam = Color.yellow
        
        static let defaultLessonType = Color.gray
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
        static let hometask = "pencil.line"
        static let information = "info"
    }
    
    struct Ranges {
        static let weeks = 0...3
        static let weekdays = 1...7
    }
    
    static let alphabet = ["А", "Б", "В", "Г", "Д", "Е", "Ё", "Ж", "З", "И", "Й", "К", "Л", "М", "Н", "О", "П", "Р", "С", "Т", "У", "Ф", "Х", "Ц", "Ч", "Ш", "Щ", "Ъ", "Ы", "Ь", "Э", "Ю", "Я"]
    
    static let searchDebounceTime: DispatchQueue.SchedulerTimeType.Stride = .milliseconds(200)
    static let placeholderDebounce: DispatchQueue.SchedulerTimeType.Stride = .milliseconds(1)
    
    static let relativeFormatDatesRange = -1...1
    static let todayCheckPublisherRange = relativeFormatDatesRange.lowerBound...5
    
}
