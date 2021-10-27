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
                    Menu {
                        GroupToolbarMenu(selectedFaculty: $selectedFaculty, selectedEducationType: $selectedEducationType, sortedBy: $sortedBy)
                    } label: {
                        Image(systemName: (selectedFaculty == nil && selectedEducationType == nil) ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
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
