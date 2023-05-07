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
    
    static let relativeDateFormatterDatesRange = -1...1
    static let todayCheckPublisherDatesRange = relativeDateFormatterDatesRange.lowerBound...5
    
}
