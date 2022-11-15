//
//  LessonsSection.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 30.05.22.
//

import Foundation

struct LessonsSection: Hashable {
    var date: Date?
    
    var week: Int
    var weekday: WeekDay
    
    var lessons: [Lesson]
    
    var title: String {
        dateBasedTitle ?? weekBasedTitle
    }
    
    init (week: Int, weekday: WeekDay, date: Date? = nil, lessons: [Lesson]) {
        self.week = week
        self.weekday = weekday
        self.date = date
        
        self.lessons = lessons
            .sorted(by: {$0.subgroup < $1.subgroup})
            .sorted(by: {$0.timeStart < $1.timeStart})
    }
    
    mutating func addLessons(lessons: [Lesson]) {
        self.lessons.append(contentsOf: lessons)
        self.lessons = lessons
            .sorted(by: {$0.subgroup < $1.subgroup})
            .sorted(by: {$0.timeStart < $1.timeStart})
    }
    
    func lessons(_ searchText: String) -> [Lesson] {
        if searchText == "" {
            return lessons
        } else {
            return lessons.filter({ $0.abbreviation.localizedStandardContains(searchText) })
        }
    }
    
    //MARK: Title
    var dateBasedTitle: String? {
        guard let date = date else  {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_BY")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "EEEEEE, d MMMM"
        let dateString = dateFormatter.string(from: date)
        return "\(dateString), \(week + 1)-ая неделя"
    }
    
    var weekBasedTitle: String {
        "\(weekday.description), \(week + 1)-ая неделя"
    }
    
    func nearestLesson() -> Lesson? {
        let currentTime = Date().time
        
        return lessons.first { currentTime < $0.timeRange.lowerBound || $0.timeRange.contains(currentTime) }
    }
}

extension LessonsSection: Identifiable {
    var id: String { date?.formatted() ?? "\(week)-\(weekday)"}
}
