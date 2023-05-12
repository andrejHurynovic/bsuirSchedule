//
//  EducationTaskViewModel.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 12.05.23.
//

import SwiftUI
import Combine

class EducationTaskViewModel: ObservableObject {
    var deadline: Date?
    
    @Published var deadlineString: String?
    var timerCancellable: AnyCancellable?
    
    init(deadline: Date?) {
        if let deadline = deadline {
            self.deadline = deadline
            deadlineString = createDeadlineString()
            addTimerCancellable()
        }
    }
    
    private func addTimerCancellable() {
        self.timerCancellable = Timer.publish(every: 1.0, on: .main, in: .default)
            .autoconnect()
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                let deadlineString = createDeadlineString()
                guard self.deadlineString != deadlineString else { return }
                withAnimation {
                    self.deadlineString = deadlineString
                }
            })
    }
    
    private func createDeadlineString() -> String {
        deadline!.formatted(.relative(presentation: .numeric, unitsStyle: .abbreviated))
    }
}
