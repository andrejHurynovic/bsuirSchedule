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
    
    //MARK: - Title
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
        guard let dateString = dateString else {
            return nil
        }
        return "\(dateString), \(week + 1)-ая неделя"
    }
    
    var weekBasedTitle: String {
        "\(weekday.description), \(week + 1)-ая неделя"
    }
        
    //MARK: - Other
    func nearestLesson() -> Lesson? {
        let currentTime = Date().time
        
        return lessons.first { currentTime < $0.timeRange.lowerBound || $0.timeRange.contains(currentTime) }
    }
}

extension LessonsSection: Identifiable {
    var id: String { date?.formatted() ?? "\(week)-\(weekday)"}
}

//MARK: - Description
extension LessonsSection {
    func nextLessons(subgroup: Int? = nil) -> [Lesson] {
        var lessons = self.lessons
        lessons.filter(subgroup: subgroup)
        
        let currentTime = Date().time
        let nearestLesson = lessons.first { currentTime < $0.timeRange.lowerBound || $0.timeRange.contains(currentTime) }
        guard let nearestLesson = nearestLesson else {
            return []
        }
        
        let nearestLessonIndex = lessons.firstIndex(of: nearestLesson)!
        let indexesRange: ClosedRange<Int>!
        indexesRange = 0...nearestLessonIndex
        lessons.removeSubrange(indexesRange)
        
        return lessons
    }
    
    func groupedByType(_ lessons: [Lesson]) -> [LessonType:[Lesson]] {
        let lessonsTypes = Set((lessons.map { $0.lessonType })).sorted { $0.rawValue < $1.rawValue }
        var groups: [LessonType:[Lesson]] = [:]
        
        for lessonsType in lessonsTypes {
            let lessonsOfLessonType = lessons.filter { $0.lessonType == lessonsType }
            groups[lessonsType] = lessonsOfLessonType
        }
        return groups
    }
    
    func calculateString(_ groupedLessons: [LessonType:[Lesson]]) -> String {
        var strings: [String] = []
        for lessonGroup in groupedLessons {
            strings.append("\(lessonGroup.key.abbreviation) (\(lessonGroup.value.count))")
        }
        return strings.joined(separator: ", ")
    }
    
    func subDescription(_ lessons: [Lesson]) -> String? {
        guard lessons.isEmpty == false else {
            return nil
        }
        let groupedLessons = groupedByType(lessons)
        let string = calculateString(groupedLessons)
        
        return "\(lessons.count) пары из которых: \(string)"
        
    }
    
    func description(divideSubgroups: Bool = false) -> String? {
        
        if divideSubgroups {
            var returnString = ""
            let firstNextLessons = nextLessons(subgroup: 1)
            if let firstSubgroupDescription = (subDescription(firstNextLessons)) {
                returnString.append("1-я п.: \(firstSubgroupDescription)")
            }
            let secondNextLessons = nextLessons(subgroup: 2)
            if let secondSubgroupDescription = (subDescription(secondNextLessons)) {
                returnString.append("\n2-я п.: \(secondSubgroupDescription)")
            }
            
            guard returnString.isEmpty == false else {
                return nil
            }
            
            return "И ещё: \(returnString)"
        } else {
            guard let subDescription = subDescription(nextLessons()) else {
                return nil
            }
            return "И ещё пары \(subDescription)"
        }
        
    }

}
