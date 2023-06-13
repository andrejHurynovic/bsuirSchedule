//
//  PrimaryScheduleView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 30.04.23.
//

import SwiftUI

struct PrimaryScheduleView<ScheduledType: Scheduled>: View {
    @ObservedObject var viewModel: PrimaryScheduleViewModel<ScheduledType>
    
    var body: some View {
        Section {
            switch viewModel.state {
                case .updating:
                    ProgressView()
                        .foregroundColor(.gray)
                case .showLesson:
                    if let lesson = viewModel.lesson {
                        LessonView(lesson: lesson, today: false)
                            .padding(.horizontal)
                            .environmentObject(ScheduledType.defaultLessonConfiguration())
                    }
                case .noClosestSection:
                    VStack {
                        Image(systemName: "calendar.badge.minus")
                            .font(.title2)
                            .bold()
                        Text("Больше занятий нет")
                            .foregroundColor(.gray)
                            .font(.footnote)
                    }
            }
        } header: {
            NavigationLink {
                ScheduleView(scheduled: viewModel.scheduled)
            } label: {
                HeaderView(viewModel.title, withArrow: true)
                    .padding(.horizontal)
                
            }
        }
        
    }
}

struct ClosestScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        let employees: [Employee] = Employee.getAll()
        if let scheduled = employees.first(where: { $0.lastName == "Перцев" }) {
            NavigationView {
                ScrollView {
                    PrimaryScheduleView(viewModel: PrimaryScheduleViewModel(scheduled: scheduled))
                        .padding(.horizontal)
                }
                .baseBackground()
            }
        }
    }
}
