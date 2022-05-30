//
//  ClassroomDetailedView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 17.10.21.
//

import SwiftUI

struct ClassroomDetailedView: View {
    var classroom: Classroom
    
    @State var selectedFaculty: Faculty? = nil
    @State var selectedEducationType: Int? = nil
    @State var sortedBy: GroupSortingType = .speciality
    
    var body: some View {
        List {
            if let departmentName = classroom.departmentName {
                Section("Информация") {
                    Text(departmentName.capitalizingFirstLetter())
                    }
                }
            if classroom.lessons?.allObjects.isEmpty == false {
                NavigationLink {
//                    LessonsView(viewModel: LessonsViewModel(classroom))
                } label: {
                    Label("Расписание кабинета", systemImage: "calendar")
                }
            }
            
            if let groups = LessonStorage.groups(lessons: classroom.lessons), groups.isEmpty == false {
                Section("Группы") {}
                    GroupList(groups: groups, searchText: nil, selectedFaculty: $selectedFaculty, selectedEducationType:
                                $selectedEducationType, sortedBy: $sortedBy)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    FavoriteButton(classroom.favorite, circle: true) {
                        classroom.favorite.toggle()
                    }
                    GroupToolbarMenu(selectedFaculty: $selectedFaculty, selectedEducationType: $selectedEducationType, sortedBy: $sortedBy)
                } label: {
                    Image(systemName: (selectedFaculty == nil && selectedEducationType == nil) ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
                }
            }
        }
        .navigationTitle(classroom.formattedName(showBuilding: true))
    }
}
