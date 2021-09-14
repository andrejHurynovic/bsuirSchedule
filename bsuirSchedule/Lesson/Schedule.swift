//
//  Schedule.swift
//  Schedule
//
//  Created by Andrej Hurynovič on 13.09.21.
//

import Foundation



class Schedule: Decodable {

    enum WeekDay: String, Decodable {
        case Monday = "Понедельник"
        case Tuesday = "Вторник"
        case Wednesday = "Среда"
        case Thursday = "Четверг"
        case Friday = "Пятница"
        case Saturday = "Суббота"
        case Sunday = "Воскресенье"
    }

    var weekDay: WeekDay!
    var lessons: [Lesson]!

    required init(form decoder: Decoder) throws {
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        self.weekDay = WeekDay.init(rawValue: try! container.decode(String.self, forKey: .weekDay))
        self.lessons = try! container.decode([Lesson].self, forKey: .lessons)
    }

    private enum CodingKeys: String, CodingKey {
        case weekDay = "weekDay"
        case lessons = "schedule"
    }
}
