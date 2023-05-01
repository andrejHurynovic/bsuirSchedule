//
//  LessonViewConfiguration.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 24.04.23.
//

import Foundation

class LessonViewConfiguration: ObservableObject {
    @Published var showAbbreviation: Bool
    
    @Published var showGroups: Bool
    @Published var showEmployees: Bool
    
    @Published var showWeeks: Bool
    @Published var showDates: Bool
    @Published var showDate: Bool
    
    init(showAbbreviation: Bool = true,
         showGroups: Bool,
         showEmployees: Bool,
         showWeeks: Bool = false,
         showDates: Bool = false,
         showDate: Bool = false) {
        self.showAbbreviation = showAbbreviation
        
        self.showGroups = showGroups
        self.showEmployees = showEmployees
        
        self.showWeeks = showWeeks
        self.showDates = showDates
        self.showDate = showDate
    }

}

//MARK: Equatable

extension LessonViewConfiguration: Equatable {
    static func == (lhs: LessonViewConfiguration, rhs: LessonViewConfiguration) -> Bool {
        return lhs.showAbbreviation == rhs.showAbbreviation &&
        lhs.showGroups == rhs.showGroups &&
        lhs.showEmployees == rhs.showEmployees &&
        lhs.showWeeks == rhs.showWeeks &&
        lhs.showDates == rhs.showDates &&
        lhs.showDate == rhs.showDate
    }
}

//MARK: Protocol

protocol DefaultLessonViewSettings {
    static func defaultLessonSettings() -> LessonViewConfiguration
}

//MARK: Extensions

extension Group {
    static func defaultLessonSettings() -> LessonViewConfiguration {
        LessonViewConfiguration(showGroups: false,
                           showEmployees: true)
    }
}
extension Employee {
    static func defaultLessonSettings() -> LessonViewConfiguration {
        LessonViewConfiguration(showGroups: true,
                           showEmployees: false)
    }
}
extension Auditorium {
    static func defaultLessonSettings() -> LessonViewConfiguration {
        LessonViewConfiguration(showGroups: true,
                           showEmployees: true)
    }
}
