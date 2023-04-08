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
    @State var selectedFaculty: Faculty? = nil
    @State var selectedEducationType: EducationType? = nil
    @State var sortedBy: GroupSortingType = .speciality
    
    var body: some View {
        NavigationView {
            let filteredGroups = groups.filter { group in
                searchText.isEmpty == true
                || group.id.localizedStandardContains(searchText)
                || (group.speciality != nil && group.speciality!.abbreviation.localizedStandardContains(searchText))
            }
                .filtered(by: selectedFaculty, selectedEducationType)
            let sections = filteredGroups.sections(by: sortedBy)
            
            List {
                GroupsSectionsView(sections: sections, groupsCount: filteredGroups.count)
                
//                Text(filteredGroups.isEmpty == false ?
//                     "Всего групп: \(filteredGroups.count)" :
//                        "Группы с такими критериями поиска отсутствуют"
//                )
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Picker("", selection: $sortedBy) {
                            Text("номер").tag(GroupSortingType.number)
                            Text("специальность").tag(GroupSortingType.speciality)
                        }
                        Text("Факультеты:")
                        Picker("", selection: $selectedFaculty) {
                            Text("все").tag(nil as Faculty?)
                            let faculties = Set(groups.compactMap({ $0.speciality?.faculty }))
                            ForEach(faculties.sorted(by: { $0.abbreviation! < $1.abbreviation! }), id: \.self) {faculty in
                                Text(faculty.abbreviation ?? "Нет названия").tag(faculty.self as Faculty?)
                            }
                        }
                        Text("Форма обучения:")
                        Picker("", selection: $selectedEducationType) {
                            Text("все").tag(nil as EducationType?)
                            let educationTypes = Set(groups.compactMap ({ $0.speciality?.educationType }))
                            ForEach(educationTypes.sorted(by: { $0.id < $1.id }), id: \.id) { educationType in
                                Text(educationType.description)
                                    .tag(educationType as EducationType?)
                            }
                        }
                    } label: {
                        Image(systemName: (selectedFaculty == nil && selectedEducationType == nil) ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
                    }
                }
            }
            .navigationBarTitle("Группы")
            .searchable(text: $searchText, prompt: "Номер группы, специальность")
            .refreshable {
                await viewModel.update()
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
