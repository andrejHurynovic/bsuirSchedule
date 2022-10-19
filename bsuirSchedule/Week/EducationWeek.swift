//
//  EducationWeek.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 19.10.22.
//

import Foundation

extension Date {
    ///Week for this date in range [0; 3]
    ///Calculates the first of September for the date. If the first of September of this year has not yet been relative to this date, then the weeks are counted from the first of September of the previous year. The difference in weeks between dates is divided modulo 4, which gives the correct week format
    var educationWeek: Int {
        let calendar = Calendar.init(identifier: .iso8601)
        var firstSeptemberDateComponents = calendar.dateComponents([.year], from: self)
        firstSeptemberDateComponents.day = 1
        firstSeptemberDateComponents.month = 9
        
        var firstSeptember = calendar.date(from: firstSeptemberDateComponents)!
        if self < firstSeptember {
            firstSeptemberDateComponents.year! -= 1
            firstSeptember = calendar.date(from: firstSeptemberDateComponents)!
        }
        
        return firstSeptember.weeksTo(self) % 4
    }
    
    ///Calculates number of not-full weeks between two dates.
    ///
    ///If the dates are from different years, then the number of weeks in a year is added to the number of weeks since the beginning of the year of the larger date.
    ///Example:
    ///Weeks between 01.09.2022 and 31.12.2022 is 52 - 35 = 17.
    ///Weeks between 01.09.2022 and 01.01.2023 is 52 - 35 = 17, because 31.12.2022 and 01.01.2023 is Saturday and Sunday respectively, so they are counted on the same week, even though they are in different years.
    ///Weeks between 01.09.2022 and 02.01.2023 is (52 + 1) - 35 = 18, because 02.01.2023 is Monday, therefore the next week, the first week of 2023, so 52 more weeks of the previous year are added to it to keep the order of the weeks from 01.09.2022.
    func weeksTo(_ end: Date) -> Int {
        let calendar = Calendar(identifier: .iso8601)
        
        let weeksOfSelfYear = calendar.dateComponents([.weekOfYear], from: self).weekOfYear!
        var weeksOfDateYear = calendar.dateComponents([.weekOfYear], from: end).weekOfYear!
        
        let yearOfSelf = calendar.dateComponents([.year], from: self).year!
        let yearOfDate = calendar.dateComponents([.year], from: end).year!

        //52 is number of not-full in every year
        if (yearOfSelf < yearOfDate && weeksOfDateYear != 52) {
            weeksOfDateYear += 52
        }
        
        return weeksOfDateYear - weeksOfSelfYear
    }
}
