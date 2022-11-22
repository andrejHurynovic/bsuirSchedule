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
    var dateString: String? {
        guard let date = date else  {
            return nil
        }
        let daysDifference = Date().removedTime().dateComponentsTo(date, .day)
        var dateString: String
        
        if (-2...2).contains(daysDifference) {
            let relativeDateFormatter = RelativeDateTimeFormatter()
            relativeDateFormatter.locale = Locale(identifier: "ru_BY")
            relativeDateFormatter.dateTimeStyle = .named
            let dateComponents = DateComponents(day: daysDifference)
            dateString = relativeDateFormatter.localizedString(from: dateComponents)
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ru_BY")
            dateFormatter.timeZone = TimeZone.autoupdatingCurrent
            dateFormatter.dateFormat = "EEEEEE, d MMMM"
            dateString = dateFormatter.string(from: date)
        }
        return dateString
    }
    
    var dateBasedTitle: String? {
        return "\(dateString!), \(week + 1)-ая неделя"
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
