//
//  TimetableView.swift
//  TimetableView
//
//  Created by Andrej Hurynovič on 29.07.21.
//

import SwiftUI

struct LessonsView: View {
    var viewModel = LessonsViewModel()
    
    var body: some View {
        
        ZStack {
            if viewModel.lessons.isEmpty {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            } else {
                List {
                    ForEach(viewModel.dates, id: \.self) { date in
                        Text(viewModel.dateFormatter.string(from: date))
                            .font(.title2)
                            .fontWeight(.bold)
                        ForEach(viewModel.lessons(date), id: \.self) {lesson in
                            LessonView(lesson: lesson, showEmployee: true)
                        }
                    }
                    
                }
            }
        }
        .listRowSeparator(.hidden)
        .listStyle(.plain)
        .background(.clear)
        .navigationTitle(viewModel.name)
    }
}
