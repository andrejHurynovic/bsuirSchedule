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
    func lessonsSections() -> [LessonsSection]
}

extension Lesson {

}

extension LessonsSectioned {
    func lessonsSections() -> [LessonsSection] {
        let lessons = lessons?.allObjects as! [Lesson]
        var lessonsSection: [LessonsSection] = []
        educationDates.forEach { date in
            let filteredLessons = lessons.filter { lesson in
                return ((lesson.weekday == date.weekDay().rawValue &&
                lesson.weeks.contains(date.educationWeek) &&
                (lesson.dateRange?.contains(date) == true))
                //exams
                || (lesson.date == date))
            }
            
            if lessons.isEmpty == false {
                lessonsSection.append(LessonsSection(date: date, showWeek: true, lessons: filteredLessons))
            }
        }
        
        return lessonsSection
    }
    
    ///Lessons sections from specified date and time.
    ///Lessons with start time before time in specified date are removed
    func lessonsSectionsFrom(date: Date) -> [LessonsSection]{
        let currentDate = date.withTime(DateFormatters.shared.time.date(from: "00:00")!)
        let currentTime = DateFormatters.shared.time.string(from: date)
        var sections = lessonsSections().filter { $0.date >= currentDate }
        if let firstSection = sections.first, firstSection.date == currentDate {
            sections[0].lessons = sections[0].lessons.filter {$0.timeStart > currentTime}
        }
        return sections
    }
}
