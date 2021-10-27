//
//  GroupsListView.swift
//  GroupsListView
//
//  Created by Andrej Hurynovič on 5.09.21.
//

import SwiftUI

struct GroupsView: View {
    @StateObject private var viewModel = GroupsViewModel()
    
    @State var searchText = ""
    @State var selectedFaculty: Faculty? = nil
    @State var selectedEducationType: Int? = nil
    @State var sortedBy: GroupSortingType = .speciality
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    GroupList(groups: viewModel.groups, searchText: $searchText, selectedFaculty: $selectedFaculty, selectedEducationType: $selectedEducationType, sortedBy: $sortedBy)
                }
                .navigationBarTitle("Группы")
                .searchable(text: $searchText, prompt: "Номер группы, специальность")
                .refreshable {
                    viewModel.fetchGroups()
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    GroupToolbarMenu(selectedFaculty: $selectedFaculty, selectedEducationType: $selectedEducationType, sortedBy: $sortedBy)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}



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
        Menu {
            Text("Сортировка:")
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
            
        } label: {
            Image(systemName: (selectedFaculty.wrappedValue == nil && selectedEducationType.wrappedValue == nil) ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
        }
    }
}



struct GroupsListView_Previews: PreviewProvider {
    static var previews: some View {
        GroupsView()
    }
}
