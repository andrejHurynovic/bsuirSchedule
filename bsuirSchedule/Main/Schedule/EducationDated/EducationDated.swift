//
//  EducationDates.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 24.09.22.
//

import Foundation

protocol EducationDated {
    /// Education start date if provided by the API
    var educationStart: Date? { get set }
    /// Education end date if provided by the API
    var educationEnd: Date? { get set }
    /// Exams start date if provided by the API
    var examsStart: Date? { get set }
    /// Exams end date if provided by the API
    var examsEnd: Date? { get set }
    
    ///Ordered dates created from education start and end dates
    var lessonsDates: [Date] { get }
    ///Ordered dates created from exams start and end dates and mapped from all exams lessons
    var examsDates: [Date] { get }
    ///Range between the first and the last from education and exams dates
    var educationRange: ClosedRange<Date>? { get }
    ///Ordered dates created from educationRange
    var educationDates: [Date] { get }
}

//MARK: - EducationDated Extensions

extension EducationDated {
    ///Dates between educationStart and educationEnd inclusive
    var lessonsDates: [Date] {
        datesBetween(educationStart, educationEnd)
    }
    ///Dates between examsStart and examsEnd inclusive
    var examsDates: [Date] {
        datesBetween(examsStart, examsEnd)
    }
    ///Range between the earliest and the latest dates among educationStart, educationEnd, examsStart, examsEnd
    var educationRange: ClosedRange<Date>? {
        let dates = [educationStart, educationEnd, examsStart, examsEnd].compactMap {$0}.sorted()
        guard dates.isEmpty == false else {
            return nil
        }
        return dates.first!...dates.last!
    }
    ///Dates between lower and upper bound of educationRange
    var educationDates: [Date] {
        guard let range = educationRange else {
            return []
        }
        return datesBetween(range.lowerBound, range.upperBound)
    }
}

//MARK: - Lessons sequence Extensions

extension Sequence where Element == Lesson {
    var educationRange: ClosedRange<Date>? {
        let allDates = [self.compactMap { $0.startLessonDate }, self.compactMap { $0.endLessonDate }, self.compactMap { $0.date }]
            .flatMap {$0}
        guard let minimalData = allDates.min(),
              let maximalDate = allDates.max() else { return nil }
        return minimalData...maximalDate
    }
    
    var educationDates: [Date]? {
        guard let educationRange = self.educationRange else { return nil }
        
        return datesBetween(educationRange.lowerBound, educationRange.upperBound)
    }
    var dividedEducationDates: (previousDates: [Date]?, nextDates: [Date]?)? {
        let today = Calendar.autoupdatingCurrent.startOfDay(for: .now)
        guard let educationDates = self.educationDates else { return (nil, nil) }
        
        if today <= educationDates.first! { return (nil, educationDates) }
        if educationDates.last! < today { return (educationDates, nil) }
        
        var dividedArray = educationDates.split(separator: today)
        let previousDates = Array(dividedArray.removeFirst())
        
        guard let nextDates = dividedArray.last else { return (previousDates, [today]) }
        
        return (Array(previousDates), [today] + nextDates)
    }
}
