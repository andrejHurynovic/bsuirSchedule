//
//  LessonsViewModel.swift
//  LessonsViewModel
//
//  Created by Andrej Hurynovič on 19.09.21.
//

import SwiftUI
import Combine

class LessonsViewModel: ObservableObject {
    private var group: Group?
    private var employee: Employee?
    
    var isEmployee = false
    
    var name: String!
    @Published var favorite: Bool! {
        willSet {
            if let group = group {
                group.favorite = newValue
                GroupStorage.shared.save()
            }
            
            if let employee = employee {
                employee.favorite = newValue
                EmployeeStorage.shared.save()
            }
        }
    }
    
    var dates: [Date] = []
    @Published var lessons: [Lesson] = [] {
        didSet {
            if group?.educationStart != nil || employee?.educationStart != nil {
                updateDates()
            }
        }
    }
    
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_BY")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "EEEEEE, d MMMM, "
        return dateFormatter
    }
    
    private var cancelable: AnyCancellable?
    
    init(_ group: Group? = nil, _ employee: Employee? = nil) {
        self.group = group
        self.employee = employee
        
        if let group = group {
            self.name = group.id
            self.favorite = group.favorite
            
            let lessonPublisher: AnyPublisher<[Lesson], Never> = LessonStorage.shared.lessons.eraseToAnyPublisher()
                cancelable = lessonPublisher.sink { lessons in
                    self.lessons = lessons.filter({$0.groups?.contains(group) as! Bool})
                }
        }
        
        if let employee = employee {
            self.name = employee.lastName
            self.favorite = employee.favorite
            self.isEmployee = true

            let lessonPublisher: AnyPublisher<[Lesson], Never> = LessonStorage.shared.lessons.eraseToAnyPublisher()
                cancelable = lessonPublisher.sink { lessons in
                    self.lessons = lessons.filter({$0.employee == employee})
                }
        }
    }
    
    func week(_ date: Date) -> String {
        var week: Int?
        
        if let group = group {
            week = (weeksBetween(start: group.educationStart!, end: date) % 4) + 1
        }
        
        if let employee = employee {
            week = (weeksBetween(start: employee.educationStart!, end: date) % 4) + 1
        }
        return String(week!) + "-ая неделя"
    }
    
    func lessons(_ date: Date, searchText: String) -> [Lesson] {
        var week: Int?
        var day: Int?
        
        if let group = group {
            week = (weeksBetween(start: group.educationStart!, end: date) % 4) + 1
            day = Calendar(identifier: .iso8601).ordinality(of: .weekday, in: .weekOfYear, for: date)! - 1
        }
        
        if let employee = employee {
            week = (weeksBetween(start: employee.educationStart!, end: date) % 4) + 1
            day = Calendar(identifier: .iso8601).ordinality(of: .weekday, in: .weekOfYear, for: date)! - 1
        }
        return lessons.forWeekNumber(week!).forWeekDay(day!).filter{searchText.isEmpty || $0.subject!.localizedStandardContains(searchText) }
    }
    
    func dateRange() -> ClosedRange<Date> {
        var range: ClosedRange<Date>?
        if let group = group {
            range = group.educationStart!...group.educationEnd!
        }
        
        if let employee = employee {
            range = employee.educationStart!...employee.educationEnd!
        }
        
        return range!
    }
    
    func update() {
        if let group = group {
            GroupStorage.shared.update(group)
        }
        
        if let employee = employee {
            EmployeeStorage.shared.update(employee)
        }
    }
    
    private func updateDates() {
        let dayDurationInSeconds: TimeInterval = 60 * 60 * 24
        
        if let group = group {
            for date in stride(from: group.educationStart!, to: group.educationEnd!, by: dayDurationInSeconds) {
                dates.append(date)
            }
            dates.append(group.educationEnd!)
        }
        
        if let employee = employee {
            for date in stride(from: employee.educationStart!, to: employee.educationEnd!, by: dayDurationInSeconds) {
                dates.append(date)
            }
            dates.append(employee.educationEnd!)
        }
    }
}
