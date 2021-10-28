//
//  UniqueLesson.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 28.10.21.
//

import SwiftUI

struct UniqueLesson: Identifiable, Hashable {
    var id = UUID()
    
    var today: Bool = false
    
    var subject: String!
    var lessonTypeValue: Int16
    var classrooms:  NSSet?
    var note: String?
    
    var groups: NSSet?
    var subgroup: Int16
    
    var date: Date?
    var weeks: [Int]!
    var weekDayValue: Int16
    var timeStart: String!
    var timeEnd: String!
    
    var employees: NSSet?
    
    func timeRange() -> ClosedRange<Date> {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        let startTime = dateFormatter.date(from: timeStart)!
        let endTime = dateFormatter.date(from: timeEnd)!
        
        return startTime...endTime
    }
    
    func relativelyNow() -> ComparisonResult {
        return timeRange().compare(date: Date())
    }
    
    func getLessonTypeAbbreviation() -> String {
        switch self.lessonType {
        case .none:
            return "Без типа"
        case .lecture:
            return "ЛК"
        case .remoteLecture:
            return "УЛК"
        case .practice:
            return "ПЗ"
        case .remotePractice:
            return "УПЗ"
        case .laboratory:
            return "ЛР"
        case .consultation:
            return "Конс"
        case .exam:
            return "Экз"
        case .candidateText:
            return "КЗ"
        }
    }
    
    init(_ lesson: Lesson) {
        self.subject = lesson.subject
        self.lessonTypeValue = lesson.lessonTypeValue
        self.classrooms = lesson.classrooms
        self.note = lesson.note
        self.groups = lesson.groups
        self.subgroup = lesson.subgroup
        self.date = lesson.date
        self.weeks = lesson.weeks
        self.weekDayValue = lesson.weekDayValue
        self.timeStart = lesson.timeStart
        self.timeEnd = lesson.timeEnd
        self.employees = lesson.employees
    }
}


extension UniqueLesson {
    var lessonType: LessonType {
        get {
            return LessonType(rawValue: self.lessonTypeValue)!
        }
        set {
            self.lessonTypeValue = newValue.rawValue
        }
    }
    
    var weekDay: WeekDay {
        get {
            return WeekDay(rawValue: self.weekDayValue)!
        }
        set {
            self.weekDayValue = newValue.rawValue
        }
    }
}
