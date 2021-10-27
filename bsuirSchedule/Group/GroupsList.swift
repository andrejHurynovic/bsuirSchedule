//
//  GroupsList.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 27.10.21.
//

import SwiftUI

struct GroupList: View {
    var groups: [Group]
    
    var searchText: Binding<String>? = .constant("")
    var selectedFaculty: Binding<Faculty?> = .constant(nil)
    var selectedEducationType: Binding<Int?> = .constant(nil)
    var sortedBy: Binding<GroupSortingType> = .constant(.speciality)
    
    var body: some View {
        ForEach (GroupStorage.sections(groups, searchText?.wrappedValue ?? "", selectedFaculty.wrappedValue, selectedEducationType.wrappedValue, sortedBy.wrappedValue), id: \.self) { section in
            Section(section.title) {
                ForEach(section.groups, id: \.id, content: { group in
                    NavigationLink(destination: LessonsView(viewModel: LessonsViewModel(group))){
                        Text(group.id)
                    }
                    .contextMenu {
                        FavoriteButton(group.favorite) {
                            group.favorite.toggle()
                        }
                    }
                })
            }
        }
    }
}
    
struct GroupToolbarMenu: View {
    var selectedFaculty: Binding<Faculty?> = .constant(nil)
    var selectedEducationType: Binding<Int?> = .constant(nil)
    var sortedBy: Binding<GroupSortingType> = .constant(.speciality)
    
    var body: some View {
//            Text("Сортировка:")
            Picker("", selection: sortedBy) {
                Text("номер").tag(GroupSortingType.number)
                Text("специальность").tag(GroupSortingType.speciality)
            }
            Text("Факультеты:")
            Picker("", selection: selectedFaculty) {
                Text("все").tag(nil as Faculty?)
                ForEach(FacultyStorage.shared.faculties() , id: \.self) {faculty in
                    Text(faculty.abbreviation).tag(faculty.self as Faculty?)
                }
            }
            Text("Форма обучения:")
            Picker("", selection: selectedEducationType) {
                Text("все").tag(nil as Int?)
                Text("дневная").tag(1 as Int?)
                Text("заочная").tag(2 as Int?)
                Text("дистанционная").tag(3 as Int?)
                Text("вечерняя").tag(4 as Int?)
            }
    }
}
