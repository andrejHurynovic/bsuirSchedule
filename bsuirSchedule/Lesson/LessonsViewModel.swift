//
//  LessonsViewModel.swift
//  LessonsViewModel
//
//  Created by Andrej Hurynovič on 19.09.21.
//

import SwiftUI
import Combine
import CoreData

protocol Lessonable: NSManagedObject {
    var favorite: Bool { get set }
    var lessons: NSSet? { get set }
    
    var educationStart: Date? { get set }
    var educationEnd: Date? { get set }
    var examsStart: Date? { get set }
    var examsEnd: Date? { get set }
}


struct LessonsSection: Hashable {
    var date: Date
    var title: String
    var lessons: [UniqueLesson]
    
    func lessons(_ searchText: String) -> [UniqueLesson] {
        if searchText == "" {
            return lessons
        } else {
            return lessons.filter({ $0.subject.localizedStandardContains(searchText) })
        }
    }
    
}

class LessonsViewModel: ObservableObject {
    
    var element: Lessonable!
    
    var sections: [LessonsSection] = []
    var nearSection: LessonsSection? = nil
    
    var title: String? = nil
    
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
    }
    
    // MARK: Sections
    
    func educationSections() -> [LessonsSection]? {
        guard let dates = educationDates() else {
            return nil
        }
        
        var sections: [LessonsSection] = []
        
        dates.forEach { date in
            if let lessons = lessons(week: week(date: date), weekDay: weekDay(date: date)), lessons.isEmpty == false {
                var fuckLessons: [UniqueLesson] = []
                lessons.forEach { lesson in
                    fuckLessons.append(UniqueLesson(lesson: lesson))
                }
                sections.append(LessonsSection(date: date, title: title(date, showWeek: true), lessons: fuckLessons))
            }
        }
        
        return sections
    }
    
    func examsSections() -> [LessonsSection]? {
        
        var sections: [LessonsSection] = []
        var dates = Set((element.lessons?.allObjects as! [Lesson]).compactMap({ $0.date }))
        
        dates.remove(Date(timeIntervalSince1970: 419420))
        
        dates.sorted().forEach { date in
            if let lessons = lessons(date: date) {
                var fuckLessons: [UniqueLesson] = []
                lessons.forEach { lesson in
                    fuckLessons.append(UniqueLesson(lesson: lesson))
                }
                sections.append(LessonsSection(date: date, title: title(date, showWeek: false), lessons: fuckLessons))
            }
        }
        
        return sections
    }
    
    
    func nearestSection(_ toDate: Date) -> LessonsSection? {
        let date = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: toDate)!
        
        return sections.filter{ $0.date >= date }.first
    }
    
    //MARK: Lessons
    
    func lessons(week: Int, weekDay: WeekDay) -> [Lesson]? {
        (element.lessons?.allObjects as! [Lesson]).sorted(by: { $0.timeStart < $1.timeStart}).filter{ $0.weeks.contains(where: {$0 == week || $0 == 0}) && $0.weekDay == weekDay }
    }
    
    func lessons(date: Date) -> [Lesson]? {
        (element.lessons?.allObjects as! [Lesson]).sorted(by: { $0.timeStart < $1.timeStart}).filter{ $0.date == date }
    }
    
    //MARK: Dates
    
    func educationDates() -> [Date]? {
        guard element.educationStart != nil else {
            return nil
        }
        
        return datesBetween(element.educationStart!, element.educationEnd!)
    }
    
    func examsDates() -> [Date]? {
        guard element.examsStart != nil else {
            return nil
        }
        
        return datesBetween(element.examsStart!, element.examsEnd!)
    }
    
    func educationRange() -> ClosedRange<Date> {
        var allDates: [Date] = []
        allDates.append(contentsOf: educationDates() ?? [])
        allDates.append(contentsOf: examsDates() ?? [])
        
        if allDates.isEmpty {
            return ClosedRange<Date>.init(uncheckedBounds: (lower: Date(), upper: Date()))
        } else {
            return ClosedRange<Date>.init(uncheckedBounds: (lower: allDates.first!, upper: allDates.last!))
        }
        
    }
    
    func datesBetween(_ dateA: Date, _ dateB: Date) -> [Date] {
        let dayDurationInSeconds: TimeInterval = 60 * 60 * 24
        var dates: [Date] = []
        
        for date in stride(from: dateA, to: dateB, by: dayDurationInSeconds) {
            dates.append(date)
        }
        dates.append(dateB)
        
        return dates
    }
    
    func week(date: Date) -> Int {
        weeksBetween(start: element.educationStart!, end: date) % 4 + 1
    }
    
    func weekDay(date: Date) -> WeekDay {
        WeekDay(rawValue: Int16((Calendar(identifier: .iso8601).ordinality(of: .weekday, in: .weekOfYear, for: date)! - 1)))!
    }
    
    //MARK: View helpers
    
    func title(_ date: Date, showWeek: Bool) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_BY")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "EEEEEE, d MMMM"
        
        let dateString = dateFormatter.string(from: date)
        
        if showWeek {
            return "\(dateString), \(week(date: date))-ая неделя"
        } else {
            return dateString
        }
    }
    
    func checkDefaults() -> Bool {
        if let _ = element as? Group {
            if showEmployees == true,
               showGroups == false {
                return true
            }
        }
        
        if let _ = element as? Employee {
            if showEmployees == false,
               showGroups == true {
                return true
            }
        }
        
        return false
    }
    
    func toggleFavorite() {
        element.favorite.toggle()
        try! PersistenceController.shared.container.viewContext.save()
    }
    
}



struct UniqueLesson: Identifiable, Hashable {
    var id = UUID()
    
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
    
    init(lesson: Lesson) {
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
