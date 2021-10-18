//
//  ClassroomDetailedView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 17.10.21.
//

import SwiftUI

struct ClassroomDetailedView: View {
    var classroom: Classroom
    
    var body: some View {
        List {
                Section("Информация") {
                    if let departmentName = classroom.departmentName {
                        Text("Кафедра: \(departmentName)")
                    }
                }
            if classroom.lessons?.allObjects.isEmpty == false {
                NavigationLink {
                    LessonsView(viewModel: LessonsViewModel(nil, nil, classroom))
                } label: {
                    Label("Расписание кабинета", systemImage: "calendar")
                }
            }

            if let groups = classroom.groups(), groups.isEmpty == false {
                Section("Группы") {
                    ForEach(groups) { group in
                        NavigationLink {
                            LessonsView(viewModel: LessonsViewModel(group, nil, nil))
                        } label: {
                            Text(group.id!)
                        }
                    }
                }
            }
        }.navigationTitle("\(classroom.name!)-\(String(classroom.building))")
    }
}
