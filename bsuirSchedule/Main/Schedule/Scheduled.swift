//
//  Scheduled.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 25.09.22.
//

import CoreData

protocol Scheduled: Favored,
                    EducationDated,
                    DefaultLessonViewSettings {
    var lessons: NSSet? { get }
    var title: String { get }
}

extension Scheduled {
    //MARK: - Date-based
//    var dateBasedLessonsSections: [ScheduleSection] {
//        let startTime = CFAbsoluteTimeGetCurrent()
//
//        let lessons = self.lessons?.allObjects as! [Lesson]
//
//        var lessonsSections: [LessonsSection] = []
//        educationDates.forEach { date in
//            let week = date.educationWeek
//            let weekday = date.weekDay()
//
//            let filteredLessons = lessons.filter { lesson in
//                return ((lesson.weekday == weekday.rawValue &&
//                         lesson.weeks.contains(week) &&
//                         (lesson.dateRange?.contains(date) == true)) ||
//                        //exams
//                        (lesson.date == date))
//            }
//
//            if filteredLessons.isEmpty == false {
//                lessonsSections.append(LessonsSection(date: date,
//                                                      educationWeek: week,
//                                                      weekday: weekday.rawValue,
//                                                      lessons: filteredLessons))
//            }
//        }
//
//        Log.info("Sections \(lessonsSections.count) has been created, time: \((CFAbsoluteTimeGetCurrent() - startTime).roundTo(places: 3)) seconds")
//
//        return lessonsSections
//    }
    
//    var nearestDateBasedSection: LessonsSection? {
//        let date = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
//        return dateBasedLessonsSections.first(where: { section in
//            let todayOrLater = section.date! >= date
//            let tomorrowOrLater = section.date != date
//            let classesLeftToday =  section.date == date && section.nearestLesson() != nil
//
//            return todayOrLater && (tomorrowOrLater || classesLeftToday)
//        })
//    }
    
//    var todayDateBasedSection: LessonsSection? {
//        return dateBasedLessonsSections.first { Calendar.current.isDateInToday($0.date!)}
//    }
    
    //MARK: - Week-based
//    var weekBasedLessonsSections: [LessonsSection] {
//        let lessons = self.lessons?.allObjects as! [Lesson]
//
//        var lessonsSections: [LessonsSection] = []
//        for week in 0...3 {
//            let weekLessons = lessons.filter { $0.weeks.contains(week) }
//            for weekday in 0...6 {
//                let weekdayLessons = weekLessons.filter { $0.weekday == weekday }
//                if weekdayLessons.isEmpty == false {
//                    lessonsSections.append(LessonsSection(educationWeek: week,
//                                                          weekday: Int16(weekday),
//                                                          lessons: weekdayLessons))
//                }
//            }
//        }
//
//        return lessonsSections
//    }
    
//    var nearestWeekBasedSection: LessonsSection? {
//        let date = Date()
//        let week = date.educationWeek
//        let weekday = date.weekDay()
//
//        return weekBasedLessonsSections.first { section in
//            let thisWeekOrLater = section.educationWeek >= week
//            let thisDayOfTheWeekAndLaterThisWeek = (section.educationWeek > week || section.weekday.rawValue >= weekday.rawValue)
//            let notToday =  !(section.educationWeek == week && section.weekday == weekday)
//            let classesLeftToday = section.educationWeek == week && section.weekday == weekday && section.nearestLesson() != nil
//
//            return thisWeekOrLater && thisDayOfTheWeekAndLaterThisWeek && (notToday || classesLeftToday)
//        }
//
//    }
    
//    var todayWeekBasedSection: LessonsSection? {
//        let date = Date()
//        let week = date.educationWeek
//        let weekday = date.weekDay()
//
//        return weekBasedLessonsSections.first { $0.educationWeek == week && $0.weekday == weekday }
//    }
    
//    func dateBasedLessonsSectionsForStatistics() -> [LessonsSection] {
//        let lessons = lessons?.allObjects as! [Lesson]
//        var lessonsSections: [LessonsSection] = []
//        educationDates.forEach { date in
//            let week = date.educationWeek
//            let weekday = date.weekDay()
//            
//            let filteredLessons = lessons.filter { lesson in
//                return ((lesson.weekday == weekday.rawValue &&
//                         lesson.weeks.contains(week) &&
//                         (lesson.dateRange?.contains(date) == true)) ||
//                        //exams
//                        (lesson.date == date))
//            }
//            
//            if filteredLessons.isEmpty == false {
//                lessonsSections.append(LessonsSection(date: date,
//                                                      educationWeek: week,
//                                                      weekday: weekday.rawValue,
//                                                      lessons: filteredLessons))
//            }
//            lessonsSections.removeAll { $0.lessons.isEmpty }
//        }
//        
//        return lessonsSections
//    }
    
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
