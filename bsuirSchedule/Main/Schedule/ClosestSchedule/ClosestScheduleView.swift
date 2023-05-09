//
//  ClosestScheduleView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 30.04.23.
//

import SwiftUI

struct ClosestScheduleView<ScheduledType: Scheduled>: View {
    @StateObject var viewModel: ClosestScheduleViewModel<ScheduledType>
    
    var body: some View {
        switch viewModel.state {
            case .updating:
                ProgressView()
                    .foregroundColor(.gray)
            case .showLesson:
                if let lesson = viewModel.lesson {
                    LessonView(lesson: lesson, today: false)
                        .padding(.horizontal)
                        .environmentObject(ScheduledType.defaultLessonSettings())
                }
            case .noClosestSection:
                Text("Все занятия прошли")
        }
    }
}

struct ClosestScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        let employees: [Employee] = Employee.getAll()
        if let scheduled = employees.first(where: { $0.lastName == "Перцев" }) {
            NavigationView {
                ScrollView {
                    ClosestScheduleView(viewModel: ClosestScheduleViewModel(scheduled: scheduled))
                        .padding(.horizontal)
                }
                .baseBackground()
            }
        }
    }
}
