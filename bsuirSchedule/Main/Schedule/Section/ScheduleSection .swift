//
//  ScheduleSection.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 30.05.22.
//

import SwiftUI
import Combine

class ScheduleSection: ObservableObject {
    var type: ScheduleSectionType
    var date: Date?
    var educationWeek: Int
    var weekday: WeekDay
    
    @Published var title: String = ""
    
    @Published var lessons: [Lesson]
    
    private var timerCancellable: AnyCancellable?
    private var relativity: Int?
    @Published var today: Bool = false
    
    //MARK: - Initialization
    
    init(type: ScheduleSectionType,
         date: Date? = nil,
         educationWeek: Int, weekday: Int16,
         lessons: any Sequence<Lesson>) {
        self.type = type
        self.date = date
        self.educationWeek = educationWeek
        self.weekday = WeekDay(rawValue: weekday)!
        
        self.lessons = lessons
            .sorted(by: {$0.subgroup < $1.subgroup})
            .sorted(by: {$0.timeStart < $1.timeStart})
        
        self.title = dateTitle ?? weekTitle
        
        self.relativity = checkRelativity()
        if let relativity = relativity,
        Constants.todayCheckPublisherDatesRange.contains(relativity) {
            addTimerCancellable()
            today = (relativity == 0)
            print(self.title)
            print(self.today)
        }
    }
    
    private func checkRelativity() -> Int? {
        switch type {
            case .date:
                guard let date = date else { return nil }
                let calendar = Calendar.autoupdatingCurrent
                let dateComponents = calendar.dateComponents([.day], from: calendar.startOfDay(for: .now), to: date)
                guard let differenceInDays = dateComponents.day else { return nil }
                
                return differenceInDays
            case .week:
                let now: Date = .now
                let nowRelativity = ((now.educationWeek * 7) + Int(now.weekDay().rawValue))
                let sectionRelativity = ((self.educationWeek * 7) + Int(self.weekday.rawValue))
                
                return sectionRelativity - nowRelativity
        }
    }
    
    private func addTimerCancellable() {
        timerCancellable = Timer.publish(every: 1.0, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self,
                let relativity = self.checkRelativity(),
                self.relativity != relativity else { return }
                
                self.relativity = relativity
                withAnimation {
                    self.title = self.dateTitle ?? self.weekTitle
                }
                guard Constants.todayCheckPublisherDatesRange.contains(relativity) else {
                    timerCancellable?.cancel()
                    today = (relativity == 0)
                    return
                }
            }
        
    }
    
    //MARK: - Title
    
    var dateTitle: String? {
        guard let dateString = dateString else { return nil }
        return "\(dateString), \(educationWeek + 1)-ая неделя"
    }
    var weekTitle: String {
        "\(weekday.description), \(educationWeek + 1)-ая неделя"
    }
    
    var dateString: String? {
        guard let date = date else { return nil }
        let calendar = Calendar.autoupdatingCurrent
        let dateComponents = calendar.dateComponents([.day], from: calendar.startOfDay(for: .now), to: date)
        guard let differenceInDays = dateComponents.day else { return nil }
        
        if Constants.relativeDateFormatterDatesRange.contains(differenceInDays) {
            let relativeDateTimeFormatter = RelativeDateTimeFormatter()
            relativeDateTimeFormatter.dateTimeStyle = .named
                
            return relativeDateTimeFormatter.localizedString(from: dateComponents)
        } else {
            return date.formatted(Date.FormatStyle()
                .weekday(.abbreviated)
                .month(.wide)
                .day(.defaultDigits))
        }
    }
    
}
