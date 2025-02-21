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
    var weekday: Int16
    
    @Published var title: String = ""
    var weekDescription: String
    
    @Published var lessons: [Lesson]
    
    private var timerCancellable: AnyCancellable?
    private var relativity: Int?
    @Published var today: Bool = false
    
    //MARK: - Initialization
    
    init(type: ScheduleSectionType, date: Date? = nil, educationWeek: Int, weekday: Int16, lessons: any Sequence<Lesson>) {
        self.type = type
        self.date = date
        self.educationWeek = educationWeek
        self.weekDescription = ", \(educationWeek + 1)-я неделя"
        self.weekday = weekday
        
        self.lessons = lessons
            .sorted(by: {$0.subgroup < $1.subgroup})
            .sorted(by: {$0.timeStart < $1.timeStart})
        
        self.updateTitle()
        
        self.relativity = checkRelativity()
        if let relativity = relativity,
           Constants.todayCheckPublisherRange.contains(relativity) {
            addTimerCancellable()
            today = (relativity == 0)
        }
    }
    
    
    private func addTimerCancellable() {
        timerCancellable = Timer.publish(every: 1.0, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                updateTitle()
                
                guard  let relativity = self.checkRelativity(),
                       self.relativity != relativity else { return }
                
                self.relativity = relativity
                guard Constants.todayCheckPublisherRange.contains(relativity) else {
                    timerCancellable?.cancel()
                    today = (relativity == 0)
                    return
                }
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
                let nowRelativity = ((now.educationWeek * 7) + Int(now.weekday))
                let sectionRelativity = ((self.educationWeek * 7) + Int(self.weekday))
                
                return sectionRelativity - nowRelativity
        }
    }
    
    //MARK: - Title
    
    private func updateTitle() {
        let updatedTitle: String = todayTitle ?? dateTitle ?? weekTitle
        guard self.title != updatedTitle else { return }
        withAnimation {
            self.title = updatedTitle
        }
    }
    
    private var todayTitle: String? {
        guard isToday(),
              let closestLesson = closestLesson() else { return nil }
        let nowTime: Date = .now.time
        if closestLesson.timeRange.contains(nowTime) {
            let lessonEnd = Date().assignedTime(from: closestLesson.timeRange.upperBound)
            return "Конец \(lessonEnd.formatted(.relative(presentation: .numeric, unitsStyle: .abbreviated)))"
        }
        if nowTime < closestLesson.timeRange.lowerBound {
            let lessonStart = Date().assignedTime(from: closestLesson.timeRange.lowerBound)
            return "Начало \(lessonStart.formatted(.relative(presentation: .numeric, unitsStyle: .abbreviated)))"
        }
        return nil
    }
    
    private var dateTitle: String? {
        guard let date = date else { return nil }
        let calendar = Calendar.autoupdatingCurrent
        let dateComponents = calendar.dateComponents([.day], from: calendar.startOfDay(for: .now), to: date)
        guard let differenceInDays = dateComponents.day else { return nil }
        
        if Constants.relativeFormatDatesRange.contains(differenceInDays) {
            
            return DateFormatters.relativeNamed.localizedString(from: dateComponents)
        } else {
            return date.formatted(Date.FormatStyle()
                .weekday(.abbreviated)
                .month(.wide)
                .day(.defaultDigits))
        }
    }
    private var weekTitle: String {
        Calendar.autoupdatingCurrent.standaloneWeekdaySymbols[Int(weekday)]
    }
}
