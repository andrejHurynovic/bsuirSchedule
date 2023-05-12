//
//  EducationDates.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 24.09.22.
//

import Foundation

protocol EducationRanged {
    ///Ordered dates created from education start and end dates
    var educationRange: ClosedRange<Date>? { get }
    ///Ordered dates created from educationRange
    var educationDates: [Date]? { get }
    
    var lessons: NSSet? { get }
}

//MARK: - EducationRanged Extensions

extension EducationRanged {
    ///Range between the earliest and the latest dates among educationStart, educationEnd, examsStart, examsEnd
    var educationRange: ClosedRange<Date>? {
        var allDates: [Date]
        if let educationDatesDecodable = self as? any EducationBounded {
            allDates = [educationDatesDecodable.educationStart,
                         educationDatesDecodable.educationEnd,
                         educationDatesDecodable.examsStart,
                         educationDatesDecodable.examsEnd].compactMap {$0}
        } else {
            guard let lessons = lessons?.allObjects as? [Lesson],
                  lessons.isEmpty == false else { return nil }
            allDates = [lessons.compactMap { $0.startLessonDate },
                            lessons.compactMap { $0.endLessonDate },
                            lessons.compactMap { $0.date }].flatMap { $0 }
        }
        
        guard allDates.isEmpty == false else { return nil}
        
        allDates.sort()
        return allDates.first!...allDates.last!
    }
    ///Dates between lower and upper bound of educationRange
    var educationDates: [Date]? {
        guard let range = educationRange else { return nil }
        return datesStride(range.lowerBound, range.upperBound)
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
        
        return datesStride(educationRange.lowerBound, educationRange.upperBound)
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
