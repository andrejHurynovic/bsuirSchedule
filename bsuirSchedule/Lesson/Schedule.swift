//
//  Schedule.swift
//  Schedule
//
//  Created by Andrej Hurynovič on 13.09.21.
//

import Foundation



class Schedule: Decodable {

    var lessons: [Lesson]!
    var dateString: String!

    required convenience public init(from decoder: Decoder) throws {
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        self.init()
        
        self.lessons = try? container.decode([Lesson].self, forKey: .lessons) 
        
        var weekDay: WeekDay?
        var date: Date?
        
        dateString = try! container.decode(String.self, forKey: .dateString)
        
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
        
        if let weekDay = weekDay {
            lessons.forEach{ $0.weekDay = weekDay }
        }
        if let date = date {
            lessons.forEach{ $0.date = date }
        }
        
    }

    private enum CodingKeys: String, CodingKey {
        case dateString = "weekDay"
        case lessons = "schedule"
    }
}
