//
//  LessonsSectioned.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 25.09.22.
//

import CoreData

protocol LessonsSectioned: NSManagedObject, EducationDated {
    var favourite: Bool { get set }
    var lessons: NSSet? { get }
    ///Creates sections with all lessons, exams and announcements ordered by date
    ///
    ///A lesson is assigned to a section under the following conditions:
    ///Lesson weekday and week is match to the date and lesson date range contains the date  (lesson),
    ///or
    ///Lesson date is match to the date (exam or announcement)
//    func dateBasedLessonsSections() -> [LessonsSection]
}

extension Lesson {

}

extension LessonsSectioned {
    
    func dateBasedLessonsSections(searchString: String, subgroup: Int?) async -> [LessonsSection] {
        var lessons = self.lessons?.allObjects as! [Lesson]
        lessons.filter(abbreviation: searchString)
        lessons.filter(subgroup: subgroup)
        
        var lessonsSections: [LessonsSection] = []
        educationDates.forEach { date in
            let week = date.educationWeek
            let weekday = date.weekDay()
            
            let filteredLessons = lessons.filter { lesson in
                return ((lesson.weekday == weekday.rawValue &&
                         lesson.weeks.contains(week) &&
                         (lesson.dateRange?.contains(date) == true)) ||
                        //exams
                        (lesson.date == date))
            }
            
            if filteredLessons.isEmpty == false {
                lessonsSections.append(LessonsSection(week: week,
                                                      weekday: weekday,
                                                      date: date,
                                                      lessons: filteredLessons))
            }
            lessonsSections.removeAll { $0.lessons.isEmpty }
        }
        
        return lessonsSections
    }
    
    func dateBasedLessonsSectionsForStatistics() -> [LessonsSection] {
        let lessons = lessons?.allObjects as! [Lesson]
        var lessonsSections: [LessonsSection] = []
        educationDates.forEach { date in
            let week = date.educationWeek
            let weekday = date.weekDay()
            
            let filteredLessons = lessons.filter { lesson in
                return ((lesson.weekday == weekday.rawValue &&
                         lesson.weeks.contains(week) &&
                         (lesson.dateRange?.contains(date) == true)) ||
                        //exams
                        (lesson.date == date))
            }
            
            if filteredLessons.isEmpty == false {
                lessonsSections.append(LessonsSection(week: week,
                                                      weekday: weekday,
                                                      date: date,
                                                      lessons: filteredLessons))
            }
            lessonsSections.removeAll { $0.lessons.isEmpty }
        }
        
        return lessonsSections
    }
    
    func weekBasedLessonsSections(searchString: String, subgroup: Int?) async -> [LessonsSection] {
        var lessons = self.lessons?.allObjects as! [Lesson]
        lessons.filter(abbreviation: searchString)
        lessons.filter(subgroup: subgroup)
        
        var lessonsSections: [LessonsSection] = []
        
        var weekdays: [WeekDay] = WeekDay.allCases
        weekdays.removeLast()
        
        for week in 0...3 {
            let weekLessons = lessons.filter { $0.weeks.contains(week) }
            for weekday in 0...6 {
                let weekdayLessons = weekLessons.filter { $0.weekday == weekday }
                if weekdayLessons.isEmpty == false {
                    lessonsSections.append(LessonsSection(week: week,
                                                          weekday: WeekDay(rawValue: Int16(exactly: weekday)!)!,
                                                          lessons: weekdayLessons))
                }
            }
        }
        

//        educationDates.forEach { date in
//            let filteredLessons = lessons.filter { lesson in
//                return ((lesson.weekday == date.weekDay().rawValue &&
//                lesson.weeks.contains(date.educationWeek) &&
//                (lesson.dateRange?.contains(date) == true))
//                //exams
//                || (lesson.date == date))
//            }
//
//            if lessons.isEmpty == false {
//                lessonsSections.append(LessonsSection(date: date, lessons: filteredLessons))
//            }
//            lessonsSections.removeAll { $0.lessons.isEmpty }
//        }
        
        return lessonsSections
    }
    
    ///Lessons sections from specified date and time.
    ///Lessons with start time before time in specified date are removed
//    func dateBasedLessonsSectionsFrom(_ date: Date) -> [LessonsSection]{
//        let currentDate = date.withTime(DateFormatters.shared.time.date(from: "00:00")!)
//        let currentTime = DateFormatters.shared.time.string(from: date)
//        var sections = dateBasedLessonsSections().filter { $0.date! >= currentDate }
//        if let firstSection = sections.first, firstSection.date == currentDate {
//            sections[0].lessons = sections[0].lessons.filter {$0.timeStart > currentTime}
//        }
//        return sections
//    }
}
