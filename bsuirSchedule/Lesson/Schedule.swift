//
//  Schedule.swift
//  Schedule
//
//  Created by Andrej Hurynovič on 13.09.21.
//

import Foundation



class Schedule: Decodable {

    var lessons: [Lesson]!
    
    var weekDay: WeekDay?
    var date: Date?

    required convenience public init(from decoder: Decoder) throws {
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        self.init()
        
        self.lessons = try? container.decode([Lesson].self, forKey: .lessons) 
        
        let dateString = try! container.decode(String.self, forKey: .dateString)
        
        switch(dateString) {
        case "Понедельник":
            weekDay = .Monday
        case "Вторник":
            weekDay = .Tuesday
        case "Среда":
            weekDay = .Wednesday
        case "Четверг":
            weekDay = .Thursday
        case "Пятница":
            weekDay = .Friday
        case "Суббота":
            weekDay = .Saturday
        case "Воскресенье":
            weekDay = .Sunday
        default:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            date = dateFormatter.date(from: dateString)
            break
        }
    
        //Если структура имеет дату, то она рассматривается как расписание экзаменов, следовательно нужно назначить каждому занятию соответствующую дату, а время оставить прежним.
        if let date = date {
            //Цикл сделан на случай, если в один день сессии будет несколько занятий, такое может быть у заочников.
            lessons.forEachInout { lesson in
                if let lessonDate = lesson.dates.first {
                    lesson.dates[0] = date.withTime(lessonDate)
                }
            }
        }
        
    }

    private enum CodingKeys: String, CodingKey {
        case dateString = "weekDay"
        case lessons = "schedule"
    }
}
