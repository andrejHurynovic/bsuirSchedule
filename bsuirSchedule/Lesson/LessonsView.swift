//
//  TimetableView.swift
//  TimetableView
//
//  Created by Andrej Hurynovič on 29.07.21.
//

import SwiftUI

struct LessonsView: View {
    @StateObject var viewModel = LessonsViewModel()
    
    var body: some View {
        
        ZStack {
            if viewModel.dates.isEmpty {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .onAppear {
                        viewModel.update()
                    }
            } else {
                List {
                    ForEach(viewModel.dates, id: \.self) { date in
                        Text(viewModel.dateFormatter.string(from: date))
                            .font(.title2)
                            .fontWeight(.bold)
                        ForEach(viewModel.lessons(date), id: \.self) { lesson in
                            LessonView(lesson: lesson, showEmployee: !viewModel.isEmployee)
                        }
                    }
                    
                }
                .listRowSeparator(.hidden)
                .listStyle(.plain)
            }
        }
        .navigationTitle(viewModel.name)
        .toolbar {
//            Button {
//
//            } label: {
//                Image(systemName: "magnifyingglass")
//            }
            Button {
                viewModel.favorite.toggle()
            } label: {
                Image(systemName: viewModel.favorite ? "star.fill" : "star")
                    .foregroundColor(.yellow)
            }
        }
    }
}
