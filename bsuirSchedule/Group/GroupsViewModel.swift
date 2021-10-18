//
//  GroupsViewModel.swift
//  GroupsViewModel
//
//  Created by Andrej Hurynovič on 11.09.21.
//

import SwiftUI
import Combine

enum GroupSortingType: Equatable, CaseIterable {
    case number
    case speciality
}

class GroupsViewModel: ObservableObject {
    @Published var groups: [Group] = []
    
    @Published var sortedBy: GroupSortingType = .speciality
    
    private var cancelable: AnyCancellable?
    
    init(groupPublisher: AnyPublisher<[Group], Never> = GroupStorage.shared.values.eraseToAnyPublisher()) {
        cancelable = groupPublisher.sink { groups in
            self.groups = groups
        }
    }
    
    func foundGroups(_ searchText: String) -> [GroupSection] {
        var sections: [GroupSection] = []
        
        let foundGroups = groups.filter { group in
            searchText.isEmpty ||
            group.id!.localizedStandardContains(searchText) ||
            group.speciality!.abbreviation!.localizedStandardContains(searchText)
        }
        
        switch sortedBy {
        case .number:
            var groupPrefixes = Set<String.SubSequence>()
            foundGroups.map{$0.id!.prefix(3)}.forEach { subSequence in
                groupPrefixes.insert(subSequence)
            }
            
            groupPrefixes.sorted().forEach { prefixSequence in
                sections.append(GroupSection(title: String(prefixSequence),
                                             groups: foundGroups.filter{$0.id!.prefix(3) == prefixSequence}))
            }
        case .speciality:
            SpecialityStorage.shared.values.value.forEach { speciality in
                let specialityGroups = foundGroups.filter{$0.speciality! == speciality}
                if specialityGroups.isEmpty == false {
                    sections.append(GroupSection(
                        title: "\(speciality.name!) (\(speciality.getEducationTypeDescription()), \(speciality.faculty!.abbreviation!))" ,
                        groups: specialityGroups))
                }
            }
        }
        
        
        return sections
    }
    
    func fetchGroups() {
        GroupStorage.shared.fetch()
    }
}



struct GroupSection: Hashable {
    var title: String
    var groups: [Group]
}
