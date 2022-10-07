//
//  GroupsListView.swift
//  GroupsListView
//
//  Created by Andrej Hurynovič on 5.09.21.
//

import SwiftUI

struct GroupsView: View {
    @FetchRequest(entity: Group.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Group.id, ascending: true)]) var groups: FetchedResults<Group>
    
    @StateObject private var viewModel = GroupsViewModel()
    
    @State var searchText = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                let filteredGroups = groups.filter({ searchText.isEmpty || $0.id.localizedStandardContains(searchText) })
                GroupsSectionsList(groups: filteredGroups)
                    .navigationBarTitle("Группы")
                    .searchable(text: $searchText, prompt: "Номер группы, специальность")
                    .refreshable {
                        await viewModel.updateAll()
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
