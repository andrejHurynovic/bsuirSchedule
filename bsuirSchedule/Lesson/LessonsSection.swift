//
//  LessonsSection.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 30.05.22.
//

import Foundation

struct LessonsSection: Hashable {
    var date: Date
    var title: String
    var lessons: [Lesson]
    
    init (date: Date, showWeek: Bool, lessons: [Lesson]) {
        self.date = date
        self.lessons = lessons
            .sorted(by: {$0.subgroup < $1.subgroup})
            .sorted(by: {($0.dates.first?.time())! < ($1.dates.first?.time())!})
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_BY")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "EEEEEE, d MMMM"
        
        let dateString = dateFormatter.string(from: date)
        
        if showWeek {
            //+1 для приведения от формата [0,3] к [1,4]
            title = "\(dateString), \(date.educationWeek + 1)-ая неделя"
        } else {
            title = dateString
        }
    }
    
    func lessons(_ searchText: String) -> [Lesson] {
        if searchText == "" {
            return lessons
        } else {
            return lessons.filter({ $0.subject.localizedStandardContains(searchText) })
        }
    }
    
}
