//
//  WeekStorage.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 30.05.22.
//

import Foundation

class WeekStorage: Storage<Week> {
    
    static let shared = WeekStorage(sortDescriptors: [])
        
    func fetch() {
        deleteAll()
        cancellables.insert(FetchManager.shared.fetch(dataType: .week, completion: {(week: Week) -> () in
        }))
        self.save()
    }
    
    func currentValue() -> Week {
        return WeekStorage.shared.values.value.last!
    }
}

//MARK: Extensions

extension Date {
    //Возвращает номер этой недели
    var educationWeek: Int {
        let weekObject = WeekStorage.shared.currentValue()
        
        let weekLastUpdate = weekObject.updateDate
        let currentWeek = Int(weekObject.updatedWeek)
        let weeksBetween = (weeksBetween(start: weekLastUpdate!, end: self))
        return Int((4 - ((currentWeek - weeksBetween) % 4) + 2) % 4)
    }
}

extension Array where Element == Date {
    func educationDates(weeks: [Int], weekDay: WeekDay, time: Date) -> [Date] {
        var dates = self.filter {$0.weekDay() == weekDay}
        //Если занятия нет на каждой неделе, то нужно найти только дни с соответствующими неделями
        if weeks.count < 4  {
            dates = dates.filter { date in
                weeks.contains { week in
                    return date.educationWeek == week
                }
            }
        }
        return dates.map {$0.withTime(time)}
    }
}
