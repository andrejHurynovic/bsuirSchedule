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
    var dateString: String?

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
            self.dateString = dateString
            break
        }
        
        if let weekDay = weekDay {
            lessons.forEachInout { lesson in
                lesson.weekday = weekDay.rawValue
            }
        }
        
        //Если структура имеет дату, то она рассматривается как расписание экзаменов, следовательно нужно назначить каждому занятию соответствующую дату
        if let dateString = self.dateString, dateString.isEmpty == false {
            //Цикл сделан на случай, если в один день сессии будет несколько занятий, такое может быть у заочников.
            lessons.forEachInout { lesson in
                //Дата сделана строкой из-за того, что optional значения не могут быть constraint в CoreData
                lesson.dateString = dateString
            }
        }
        
    }

    private enum CodingKeys: String, CodingKey {
        case dateString = "weekDay"
        case lessons = "schedule"
    }
}
