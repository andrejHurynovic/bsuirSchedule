//
//  GroupsSectionsList.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 27.10.21.
//

import SwiftUI

struct GroupsSectionsList: View {
    var groups: [Group]
    
    @State var selectedFaculty: Faculty? = nil
    @State var selectedEducationType: EducationType? = nil
    @State var sortedBy: GroupSortingType = .speciality
    
    var body: some View {
        List {
            let filteredGroups = groups.filtered(by: selectedFaculty, selectedEducationType)
            ForEach(filteredGroups.sections(by: sortedBy), id: \.self) { section in
                Section(section.title) {
                    ForEach(section.groups, id: \.id, content: { group in
                        NavigationLink(destination: GroupDetailedView(viewModel: GroupViewModel(group))){
                            Text(group.id)
                        }
                        .contextMenu {
                            FavoriteButton(group.favourite) {
                                group.favourite.toggle()
                            }
                        }
                    })
                }
            }
            if groups.isEmpty == false {
                Text("Всего групп: \(filteredGroups.count)")
            }
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
                        let faculties = Set(groups.compactMap({ $0.speciality.faculty }))
                        ForEach(faculties.sorted(by: { $0.name! < $1.name! }), id: \.self) {faculty in
                            Text(faculty.abbreviation).tag(faculty.self as Faculty?)
                        }
                    }
                    Text("Форма обучения:")
                    Picker("", selection: $selectedEducationType) {
                        Text("все").tag(nil as EducationType?)
                        let educationTypes = Set(groups.map ({ $0.speciality.educationType }))
                        ForEach(educationTypes.sorted(by: { $0.rawValue < $1.rawValue }), id: \.rawValue) { educationType in
                            Text(educationType.description)
                                .tag(educationType as EducationType?)
                        }
                    }
                } label: {
                    Image(systemName: (selectedFaculty == nil && selectedEducationType == nil) ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
                }
            }
        }
        
    }
}
