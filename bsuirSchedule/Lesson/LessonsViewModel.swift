//
//  LessonsViewModel.swift
//  LessonsViewModel
//
//  Created by Andrej Hurynovič on 19.09.21.
//

import SwiftUI
import Combine
import CoreData

class LessonsViewModel: ObservableObject {
    
    @Published var element: Lessonable!
    
    @Published  var sections: [LessonsSection] = []
    @Published  var nearSection: LessonsSection? = nil
    
    @Published var title: String? = nil
    
    @Published var showGroups: Bool = false
    @Published var showEmployees: Bool = false
    
    init(_ element: Lessonable) {
        self.element = element
        
        sections.append(contentsOf: educationSections() ?? [])
        sections.append(contentsOf: examsSections() ?? [])
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
    
    // MARK: Sections
    
    func educationSections() -> [LessonsSection]? {
        var sections: [LessonsSection] = []
        
        let educationDates = element.educationDates
        educationDates.forEach({ date in
            var lessons = element.lessons?.allObjects as! [Lesson]
            lessons = lessons.filter { lesson in
                lesson.dates.contains { lessonDate in
                    Calendar.current.isDate(lessonDate, inSameDayAs: date)
                }
            }
            if lessons.isEmpty == false {
                sections.append(LessonsSection(date: date, showWeek: true, lessons: lessons))
            }
        })
        return sections
    }
    
    func examsSections() -> [LessonsSection]? {
        var sections: [LessonsSection] = []
        
        let examsDates = element.examsDates
        examsDates.forEach({ date in
            var lessons = element.lessons?.allObjects as! [Lesson]
            lessons = lessons.filter { lesson in
                lesson.dates.contains { lessonDate in
                    Calendar.current.isDate(lessonDate, inSameDayAs: date)
                }
            }
            if lessons.isEmpty == false {
                sections.append(LessonsSection(date: date, showWeek: false, lessons: lessons))
            }
        })
        return sections
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
