//
//  LessonsSection.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 30.05.22.
//

import Foundation

struct LessonsSection: Hashable {
    var date: Date
    var title: String
    var lessons: [Lesson]
    
    init (date: Date, showWeek: Bool, lessons: [Lesson]) {
        self.date = date
        self.lessons = lessons
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_BY")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "EEEEEE, d MMMM"
        
        let dateString = dateFormatter.string(from: date)
        
        if showWeek {
            title = "\(dateString), \(date.educationWeek)-ая неделя"
        } else {
            title = dateString
        }
    }
    
    func lessons(_ searchText: String) -> [Lesson] {
        if searchText == "" {
            return lessons
        } else {
            return lessons.filter({ $0.subject.localizedStandardContains(searchText) })
        }
    }
    
}
