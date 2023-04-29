//
//  LessonViewSettings.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 24.04.23.
//

import Foundation

class LessonViewSettings: ObservableObject {
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

extension LessonViewSettings: Equatable {
    static func == (lhs: LessonViewSettings, rhs: LessonViewSettings) -> Bool {
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
    static func defaultLessonSettings() -> LessonViewSettings
}

//MARK: Extensions

extension Group {
    static func defaultLessonSettings() -> LessonViewSettings {
        LessonViewSettings(showGroups: false,
                           showEmployees: true)
    }
}
extension Employee {
    static func defaultLessonSettings() -> LessonViewSettings {
        LessonViewSettings(showGroups: true,
                           showEmployees: false)
    }
}
extension Auditorium {
    static func defaultLessonSettings() -> LessonViewSettings {
        LessonViewSettings(showGroups: true,
                           showEmployees: true)
    }
}
