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
    
    var body: some View {
        NavigationView {
            ZStack {
                List (viewModel.sections(searchText), id: \.self) { section in
                    Section(section.title) {
                        ForEach(section.groups, id: \.id, content: { group in
                            NavigationLink(destination: LessonsView(viewModel: LessonsViewModel(group, nil))){
                                Text(group.id ?? "")
                            }
                        })
                    }
                    
                }
                .refreshable {
                    viewModel.fetchGroups()
                }
            }
            .navigationBarTitle("Группы")
            .searchable(text: $searchText, prompt: "Номер группы, специальность")
            
            .toolbar {
                Picker("Color", selection: $viewModel.sortedBy) {
                    Text("Номер").tag(GroupSortingType.number)
                    Text("Специальность").tag(GroupSortingType.speciality)
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}



struct GroupsListView_Previews: PreviewProvider {
    static var previews: some View {
        GroupsView()
    }
}
