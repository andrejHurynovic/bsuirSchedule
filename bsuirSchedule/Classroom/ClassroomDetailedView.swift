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
            if let departmentName = classroom.departmentName {
                Section("Информация") {
                    Text(departmentName.capitalizingFirstLetter())
                    }
                }
            if classroom.lessons?.allObjects.isEmpty == false {
                NavigationLink {
                    LessonsView(viewModel: LessonsViewModel(classroom))
                } label: {
                    Label("Расписание кабинета", systemImage: "calendar")
                }
            }

            if let groups = classroom.groups(), groups.isEmpty == false {
                Section("Группы") {
                    ForEach(groups) { group in
                        NavigationLink {
                            LessonsView(viewModel: LessonsViewModel(group))
                        } label: {
                            Text(group.id!)
                        }
                    }
                }
            }
        }.navigationTitle(classroom.formattedName(showBuilding: true))
    }
}
