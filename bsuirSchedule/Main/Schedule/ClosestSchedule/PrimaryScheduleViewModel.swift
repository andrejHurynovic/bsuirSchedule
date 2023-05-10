//
//  PrimaryScheduleViewModel.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 9.05.23.
//

import SwiftUI
import Combine

class PrimaryScheduleViewModel<ScheduledType: Scheduled>: ObservableObject {
    
    var scheduled: ScheduledType
    var subgroup: Int?
    
    @Published var title: String
    var section: ScheduleSection?
    @Published var lesson: Lesson?
    
    @Published var state: PrimaryScheduleViewState = .updating
    
    private var timerCancellable: AnyCancellable?
    
    //MARK: - Initialization
    
    init(scheduled: ScheduledType, subgroup: Int? = nil) {
        self.scheduled = scheduled
        self.subgroup = subgroup
        self.title = scheduled.title
        Task {
            await update()
            if let scheduled = scheduled as? any LessonsRefreshable {
                let _ = await scheduled.checkForLessonsUpdates()
            }
        }
        addTimerCancellable()
    }
    
    private func addTimerCancellable() {
        timerCancellable = Timer.publish(every: 1.0, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
//                Task { await self.updateTitle() }
                let lesson = section?.closestLesson()
                guard self.lesson != lesson else { return }
                if let lesson = lesson {
                    withAnimation {
                        self.lesson = lesson
                    }
                } else {
                    Task { await self.update() }
                }
            }
        
    }
    
    //MARK: - Update
    
    private func update() async {
            if var lessons = scheduled.lessons?.allObjects as? [Lesson] {
                if let subgroup = subgroup {
                    lessons = Array(lessons.filtered(subgroup: subgroup))
                }
                let section = await lessons.sections(.date, educationDates: scheduled.dividedEducationDates?.nextDates)
                    .closest(to: .now, type: .date)
                self.section = section
                //Education end check
                guard let lesson = section?.closestLesson() else {
                    await MainActor.run {
                        withAnimation {
                            self.title = scheduled.title
                            self.state = .noClosestSection
                        }
                    }
                    timerCancellable?.cancel()
                    return
                }
                //Update current lesson
                await updateTitle()
                await MainActor.run {
                    withAnimation {
                        self.lesson = lesson
                        self.state = .showLesson
                    }
                }
            }
    }
    
    private func updateTitle() async { 
        guard let scheduledTitle = section?.title else { return }
        let updatedTitle = scheduled.title + ", \(scheduledTitle)"
        guard self.title != updatedTitle else { return }
        await MainActor.run {
            withAnimation {
                self.title = updatedTitle
            }
        }
    }
    
}
