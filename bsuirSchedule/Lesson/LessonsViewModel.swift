//
//  LessonsViewModel.swift
//  LessonsViewModel
//
//  Created by Andrej Hurynovič on 19.09.21.
//

import SwiftUI
import Combine

class LessonsViewModel: ObservableObject {
    var group: Group?
    var employee: Employee?
    
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
    var lessons: [Lesson] = [] {
        willSet {
            
        }
    }
    
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_BY")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "EEEE, d MMMM"
        return dateFormatter
    }
    
    
    
    init(_ group: Group? = nil, _ employee: Employee? = nil) {
        self.group = group
        self.employee = employee
        
        if let group = group {
            self.name = group.id
            self.favorite = group.favorite
            
            if group.lessons!.count != 0 {
                self.lessons = group.lessons?.allObjects as! [Lesson]
                updateDates()
            }
        }
        
        if let employee = employee {
            self.name = employee.lastName
            self.favorite = employee.favorite
            
            self.lessons = employee.lessons?.allObjects as! [Lesson]
        }
    }
    
    func lessons(_ date: Date) -> [Lesson] {
        var week: Int?
        if let group = group {
            week = (weeksBetween(start: group.educationStart!, end: date) % 4) + 1
        }
//        if let employee = employee {
//
//        }
        
        let day = Calendar(identifier: .iso8601).ordinality(of: .weekday, in: .weekOfYear, for: date)! - 1
    
        return lessons.forWeekNumber(week!).forWeekDay(day)
            
    }
    
    func update() {
        if let group = group {
            GroupStorage.shared.update(group)
        }
    }
    
    private func updateDates() {
        if let group = group {
            let dayDurationInSeconds: TimeInterval = 60 * 60 * 24
            for date in stride(from: group.educationStart!, to: group.educationEnd!, by: dayDurationInSeconds) {
                dates.append(date)
            }
            dates.append(group.educationEnd!)
        }
    }
}
