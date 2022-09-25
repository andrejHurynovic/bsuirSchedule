//
//  ClassroomDetailedView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 17.10.21.
//

import SwiftUI

struct ClassroomDetailedView: View {
    var classroom: Classroom
    
    //GroupList
    @State var selectedFaculty: Faculty? = nil
    @State var selectedEducationType: EducationType? = nil
    @State var sortedBy: GroupSortingType = .speciality
    
    var body: some View {
        List {
            department
            scheduleButton
            groups
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    FavoriteButton(classroom.favourite, circle: true) {
                        classroom.favourite.toggle()
                    }
                    GroupToolbarMenu(selectedFaculty: $selectedFaculty, selectedEducationType: $selectedEducationType, sortedBy: $sortedBy)
                } label: {
                    Image(systemName: (selectedFaculty == nil && selectedEducationType == nil) ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
                }
            }
        }
        .navigationTitle(classroom.formattedName(showBuilding: true))
    }
    
    @ViewBuilder var department: some View {
        if let departmentName = classroom.departmentName {
            Section("Информация") {
                Text(departmentName.capitalizingFirstLetter())
                }
            }
    }
    
    @ViewBuilder var scheduleButton: some View {
        if classroom.haveLessons {
            NavigationLink {
                LessonsView(viewModel: LessonsViewModel(classroom))
            } label: {
                Label("Расписание кабинета", systemImage: "calendar")
            }
        }
    }
    
    @ViewBuilder var groups: some View {
        let groups = classroom.groups
        if  groups.isEmpty == false {
            Section("Группы") {}
                GroupsList(groups: groups, searchText: nil, selectedFaculty: $selectedFaculty, selectedEducationType:
                            $selectedEducationType, sortedBy: $sortedBy)
        }
    }
    
}
