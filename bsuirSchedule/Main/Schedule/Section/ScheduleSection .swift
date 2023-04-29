//
//  ScheduleSection.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 30.05.22.
//

import Foundation

class ScheduleSection: ObservableObject {
    
    var date: Date?
    var educationWeek: Int
    var weekday: WeekDay
    
    @Published var lessons: [Lesson]
    
    var title: String { dateTitle ?? weekTitle }
    
    init(date: Date? = nil, educationWeek: Int, weekday: Int16, lessons: [Lesson]) {
        self.date = date
        self.educationWeek = educationWeek
        self.weekday = WeekDay(rawValue: weekday)!
        
        self.lessons = lessons
            .sorted(by: {$0.subgroup < $1.subgroup})
            .sorted(by: {$0.timeStart < $1.timeStart})
    }
    
    //MARK: - Title
    
    var dateTitle: String? {
        guard let dateString = dateString else { return nil }
        return "\(dateString), \(educationWeek + 1)-ая неделя"
    }
    var weekTitle: String {
        "\(weekday.description), \(educationWeek + 1)-ая неделя"
    }
    
    var dateString: String? {
        guard let date = date else { return nil }
        let calendar = Calendar.autoupdatingCurrent
        let dateComponents = calendar.dateComponents([.day], from: calendar.startOfDay(for: .now), to: date)
        guard let differenceInDays = dateComponents.day else { return nil }
        
        if (-1...1).contains(differenceInDays) {
            let relativeDateTimeFormatter = RelativeDateTimeFormatter()
            relativeDateTimeFormatter.dateTimeStyle = .named
                
            return relativeDateTimeFormatter.localizedString(from: dateComponents)
        } else {
            return date.formatted(Date.FormatStyle()
                .weekday(.abbreviated)
                .month(.wide)
                .day(.defaultDigits))
        }
    }
    
}

//MARK: - Sections

extension Sequence where Element == Lesson {
    func sections(_ type: ScheduleSectionType,
                  educationDates: [Date]? = nil) async -> [ScheduleSection] {
        switch type {
            case .date:
                return await dateSections(educationDates: educationDates)
            case .week:
                return await weekSections()
        }
    }
    
    private func dateSections(educationDates: [Date]? = nil) async -> [ScheduleSection] {
        let startTime = CFAbsoluteTimeGetCurrent()
        guard let educationDates = educationDates ?? self.educationDates else { return [] }
        
        let sections = educationDates.compactMap { date in
            let educationWeek = date.educationWeek
            let weekday = date.weekDay().rawValue
            
            let lessons = self.filter( { ($0.weekday == weekday &&
                                          $0.weeks.contains(educationWeek) &&
                                          ($0.dateRange?.contains(date) == true))
                ||
                $0.date == date } )
            guard lessons.isEmpty == false else { return nil as ScheduleSection? }
            let section = ScheduleSection(date: date,
                                          educationWeek: educationWeek,
                                          weekday: weekday,
                                          lessons: lessons)
            Log.info(section.description)
            return section
        }
        
        Log.info("dateSections \(sections.count) has been created, time: \((CFAbsoluteTimeGetCurrent() - startTime).roundTo(places: 5)) seconds")
        return sections
    }
    
    private func weekSections() async -> [ScheduleSection] {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        let sections = (0...3).flatMap { week in
            let lessonsInWeek = self.filter{ $0.weeks.contains(week) }
            return (0...6).compactMap { weekday in
                let lessonsInWeekday = lessonsInWeek.filter { $0.weekday == weekday }
                guard lessonsInWeekday.isEmpty == false else { return nil }
                let section = ScheduleSection(educationWeek: week,
                                              weekday: Int16(weekday),
                                              lessons: lessonsInWeekday)
                Log.info(section.description)
                return section
            } as [ScheduleSection]
        }
        
        Log.info("weekSections \(sections.count) has been created, time: \((CFAbsoluteTimeGetCurrent() - startTime).roundTo(places: 5)) seconds")
        return sections
    }
    
}

//MARK: - Other

extension Array where Element == ScheduleSection {
    func closest(to date: Date, type: ScheduleSectionType) async -> ScheduleSection? {
        switch type {
            case .date:
                let startOfDate = Calendar.autoupdatingCurrent.startOfDay(for: date)
                return self.first { $0.date! >= startOfDate }
            case .week:
                let date = Date()
                let week = date.educationWeek
                let weekday = date.weekDay()
                
                return self.first { section in
                    let thisWeekOrLater = section.educationWeek >= week
                    let thisDayOfTheWeekAndLaterThisWeek = (section.educationWeek > week || section.weekday.rawValue >= weekday.rawValue)
                    let notToday = !(section.educationWeek == week && section.weekday == weekday)
                    //                    let classesLeftToday = section.educationWeek == week && section.weekday == weekday && section.nearestLesson() != nil
                    
                    return thisWeekOrLater && thisDayOfTheWeekAndLaterThisWeek && (notToday)
                    //                    return thisWeekOrLater && thisDayOfTheWeekAndLaterThisWeek && (notToday || classesLeftToday)
                }
                
        }
        
    }
}


extension Array where Element == ScheduleSection {
    func filtered(abbreviation: String, subgroup: Int?) -> [ScheduleSection] {
        let filteredSections: [ScheduleSection] = self.compactMap { section in
            let lessons = section.lessons
                .filtered(abbreviation: abbreviation)
                .filtered(subgroup: subgroup)
                .map { $0 }
            if lessons.isEmpty {
                return nil
            } else {
                return ScheduleSection(date: section.date,
                                       educationWeek: section.educationWeek,
                                       weekday: section.weekday.rawValue,
                                       lessons: lessons)
            }
        }
        return filteredSections
    }
}

extension ScheduleSection {
    var description: String {
        var description = ["Section. date: \(self.date?.formatted(date: .numeric, time: .omitted) ?? "no date"), week: \(self.educationWeek), weekday: \(weekday.description)"]
        description.append(contentsOf: lessons.map { "       \($0.description)" })
        return description.joined(separator: ",\n")
    }
}

extension Lesson {
    public override var description: String {
        return "\(abbreviation) (\(lessonType.abbreviation)) \(timeStart)-\(timeEnd), groups: \((groups?.allObjects as? [Group])?.description() ?? "no groups") employees: \(employeesIDs)"
    }
}


extension ScheduleSection: Identifiable {
    var id: String { date?.formatted() ?? "\(educationWeek)-\(weekday)"}
}
extension ScheduleSection : Equatable {
    static func == (lhs: ScheduleSection, rhs: ScheduleSection) -> Bool {
        lhs.title == rhs.title
    }
}

