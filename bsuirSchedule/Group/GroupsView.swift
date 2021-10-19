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
    
    @State var showPopover = false
    
    @State var sortedBy: GroupSortingType = .speciality
    @State var selectedFaculty: Faculty? = nil
    @State var selectedEducationType: Int? = nil
    
    var body: some View {
        NavigationView {
            ZStack {
                List (viewModel.sections(searchText, selectedFaculty, selectedEducationType, sortedBy), id: \.self) { section in
                    Section(section.title) {
                        ForEach(section.groups, id: \.id, content: { group in
                            NavigationLink(destination: LessonsView(viewModel: LessonsViewModel(group, nil))){
                                Text(group.id ?? "")
                            }
                        })
                    }
                    
                }
                .navigationBarTitle("Группы")
                .searchable(text: $searchText, prompt: "Номер группы, специальность")
                .refreshable {
                    viewModel.fetchGroups()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Menu {
                        Picker("", selection: $sortedBy) {
                            Text("Номер").tag(GroupSortingType.number)
                            Text("Специальность").tag(GroupSortingType.speciality)
                        }
                        Picker("", selection: $selectedFaculty) {
                            Text("все").tag(nil as Faculty?)
                            ForEach(FacultyStorage.shared.faculties() , id: \.self) {faculty in
                                Text(faculty.abbreviation).tag(faculty.self as Faculty?)
                            }
                        }
                        Picker("", selection: $selectedEducationType) {
                            Text("все").tag(nil as Int?)
                            Text("дневная").tag(1 as Int?)
                            Text("заочная").tag(2 as Int?)
                            Text("дистанционная").tag(3 as Int?)
                            Text("вечерняя").tag(4 as Int?)
                        }
                        
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}



struct GroupsListView_Previews: PreviewProvider {
    static var previews: some View {
        GroupsView()
    }
}
