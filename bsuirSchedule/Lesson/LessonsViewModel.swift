//
//  LessonsViewModel.swift
//  LessonsViewModel
//
//  Created by Andrej Hurynovič on 19.09.21.
//

import SwiftUI
import CoreData
import Combine

class LessonsViewModel: ObservableObject {
    
    @Published var element: LessonsSectioned!
    
    @Published  var sections: [LessonsSection] = []
    @Published  var nearSection: LessonsSection? = nil
    
    @Published var title: String? = nil
    
    @Published var showGroups: Bool = false
    @Published var showEmployees: Bool = false
    
    init(_ element: LessonsSectioned) {
        self.element = element
        
        sections = element.lessonsSections()
        nearSection = nearestSection(Date())
        
        if let group = element as? Group {
            title = group.id
            showEmployees = true
        }
        
        if let employee = element as? Employee {
            title = employee.lastName
            showGroups = true
        }
        
        if let classroom = element as? Classroom {
            title = classroom.formattedName(showBuilding: true)
            showGroups = true
            showEmployees = true
        }
    }
    
    
    func nearestSection(_ toDate: Date) -> LessonsSection? {
        let date = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: toDate)!
        
        return sections.filter{ $0.date >= date }.first
    }
    
    func weekDay(date: Date) -> WeekDay {
        WeekDay(rawValue: Int16((Calendar(identifier: .iso8601).ordinality(of: .weekday, in: .weekOfYear, for: date)! - 1)))!
    }
    
    //MARK: View helpers
    
    func checkDefaults() -> Bool {
        switch element.self {
        case is Group:
            if showEmployees == true,
               showGroups == false {
                return true
            }
        case is Employee:
            if showEmployees == false,
               showGroups == true {
                return true
            }
        case is Classroom:
            if showEmployees == true,
               showGroups == true {
                return true
            }
        default:
            return false
        }
        return false
    }
    
}
