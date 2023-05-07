//
//  LessonViewModel.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 7.05.23.
//

import SwiftUI
import Combine

class LessonViewModel: ObservableObject {
    
    var lesson: Lesson
    
    var timerCancellable: AnyCancellable?
    @Published var passed: Bool = false
    
    init(lesson: Lesson, today: Bool) {
        self.lesson = lesson
        
        let time: Date = .now.time
        if today {
            if time > lesson.timeRange.upperBound {
                self.passed = true
            } else {
                addTimer()
            }
        }
    }
    
    //MARK: Subscribers
    
    func addTimer() {
        timerCancellable = Timer.publish(every: 1.0, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                let time: Date = .now.time
                guard time < lesson.timeRange.upperBound else {
                    withAnimation {
                        self.passed = true
                    }
                    timerCancellable?.cancel()
                    return
                }
            }
    }
}
