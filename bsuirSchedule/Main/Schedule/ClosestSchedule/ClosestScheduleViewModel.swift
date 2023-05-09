//
//  ClosestScheduleViewModel.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 9.05.23.
//

import SwiftUI
import Combine

class ClosestScheduleViewModel<ScheduledType: Scheduled>: ObservableObject {
    
    @Published var scheduled: ScheduledType
    
    @Published var section: ScheduleSection?
    @Published var lesson: Lesson?
    
    @Published var state: ClosestScheduleViewState = .updating
    
    private var timerCancellable: AnyCancellable?
    
    init(scheduled: ScheduledType) {
        self.scheduled = scheduled
        if let scheduled = scheduled as? any LessonsRefreshable {
            Task {
                await update()
                let _ = await scheduled.checkForLessonsUpdates()
            }
        }
        addTimerCancellable()
    }
    
    private func update() async {
            if let lessons = scheduled.lessons?.allObjects as? [Lesson] {
                let section = await lessons.sections(.date, educationDates: scheduled.dividedEducationDates?.nextDates)
                    .closest(to: .now, type: .date)
                await MainActor.run {
                    self.section = section
                }
                guard let lesson = section?.closestLesson() else {
                    await MainActor.run {
                        withAnimation {
                            state = .noClosestSection
                        }
                    }
                    timerCancellable?.cancel()
                    return
                }
                await MainActor.run {
                    withAnimation {
                        self.lesson = lesson
                        state = .showLesson
                    }
                }
            }
    }
    
    private func addTimerCancellable() {
        timerCancellable = Timer.publish(every: 1.0, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                let lesson = section?.closestLesson()
                guard self.lesson != lesson else { return }
                if let lesson = lesson {
                    withAnimation {
                        self.lesson = lesson
                    }
                } else {
                    Task {
                        await self.update()
                    }
                }
            }
        
    }
}
