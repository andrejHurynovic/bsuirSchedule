//
//  FavoriteSectionView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 17.11.22.
//

import SwiftUI

enum FavoriteSectionState: CaseIterable {
    case updating
    case nextLesson
    case noMoreLessons
}

struct FavoriteSectionView: View {
    
    @ObservedObject var viewModel: FavoriteSectionViewModel
    
    @ViewBuilder var body: some View {
        
        VStack(alignment: .leading) {
            HStack {
                HeaderView(viewModel.title)
                Spacer()
            }
            .padding(.bottom, -4)
            
            if viewModel.favoriteSectionState == .nextLesson, let lessonsViewModel = viewModel.lessonsViewModel, let lesson = viewModel.lesson  {
                NavigationLink {
                    LessonsView(viewModel: lessonsViewModel)
                } label: {
                    LessonView(lesson: lesson,
                               showEmployee: lessonsViewModel.showEmployees,
                               showGroups: lessonsViewModel.showGroups,
                               showWeeks: lessonsViewModel.showWeeks, today: false)
                    .foregroundColor(.primary)
                }
                if let description = viewModel.description() {
                    Text(description)
                        .font(.caption)
                        .foregroundColor(Color.gray)
                }
            }
            
        }
        
    }
}
