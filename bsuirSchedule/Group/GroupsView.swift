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
                List (viewModel.foundGroups(searchText), id: \.id) { group in
                    NavigationLink(destination: LessonsView(viewModel: LessonsViewModel(group, nil))){
                        Text(group.id ?? "WFt")
                    }
                }
                .refreshable {
                    viewModel.fetchGroups()
                }
                if viewModel.groups.isEmpty {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .onAppear {
//                            viewModel.fetchGroups()
                        }
                }
            }
            .navigationBarTitle("Группы")
            .searchable(text: $searchText, prompt: "Фамилия, кафедра")
//            .toolbar {
//                Button {
//                    viewModel.groups.forEach { group in
//                        viewModel.fetchGroup(group.id!)
//                    }
//                } label: {
//                    Text("SUs")
//                }
//            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct GroupsListView_Previews: PreviewProvider {
    static var previews: some View {
        GroupsView()
    }
}
