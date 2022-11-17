//
//  FavoriteSectionView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 17.11.22.
//

import SwiftUI

struct FavoriteSectionView: View {
    @State var lessonsSectioned: LessonsSectioned
    @State var viewModel: LessonsViewModel? = nil
    @State var primarySection: LessonsSection? = nil
    
    @ViewBuilder var body: some View {
        if let viewModel = viewModel, let section = primarySection, let lesson = section.nearestLesson() {
            NavigationLink {
                LessonsView(viewModel: viewModel)
            } label: {
                VStack(alignment: .leading) {
                    if let group = lessonsSectioned as? Group {
                        standardizedHeader(title: group.id)
                    }
                    if let employee = lessonsSectioned as? Employee {
                        standardizedHeader(title: employee.lastName)
                    }
                    if let classroom = lessonsSectioned as? Classroom {
                        standardizedHeader(title: classroom.formattedName(showBuilding: true))
                    }
                    
                    LessonView(lesson: lesson, showEmployee: viewModel.showEmployees, showGroups: viewModel.showGroups, showWeeks: viewModel.showWeeks, today: false)
                }
                .foregroundColor(.primary)
            }
        } else {
            ProgressView()
                .foregroundColor(.black)
                .task {
                    viewModel = LessonsViewModel(lessonsSectioned)
                    let section = viewModel?.nearestSection
                    await MainActor.run {
                        withAnimation {
                            self.primarySection = section
                        }
                    }
                }
        }
        
    }
}
