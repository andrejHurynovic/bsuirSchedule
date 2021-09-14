//
//  TimetableView.swift
//  TimetableView
//
//  Created by Andrej Hurynovič on 29.07.21.
//

import SwiftUI

struct LessonsView: View {
    var group: Group?
    var employee: Employee?
    
    @StateObject private var viewModel = GroupsViewModel()
    
    var body: some View {
        
        if let group = group {
            ZStack {
                if let lessons = (group.lessons?.allObjects as! [Lesson]) {
                    if lessons.isEmpty {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .onAppear {
                                viewModel.fetchGroup(group.id!)
                            }
                    }
                    List {
                        ForEach(lessons) { lesson in
                            LessonView(lesson: lesson, showEmployee: true)
                        }
                    }
                }
                
            }
            .listStyle(.plain)
            .background(.clear)
            .navigationTitle(group.id!)
        }
        
        if let employee = employee {
            
            if let lessons = (employee.lessons?.allObjects as? [Lesson]) {
                List {
                    ForEach(lessons) { lesson in
                        LessonView(lesson: lesson, showEmployee: false)
                    }
                }
                .listStyle(.plain)
                .background(.clear)
                .navigationTitle(employee.lastName!)
            }
        }
    }
}
