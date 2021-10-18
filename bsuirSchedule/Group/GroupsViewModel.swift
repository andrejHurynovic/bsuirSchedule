//
//  GroupsViewModel.swift
//  GroupsViewModel
//
//  Created by Andrej Hurynovič on 11.09.21.
//

import SwiftUI
import Combine

struct GroupSection: Hashable {
    var title: String
    var groups: [Group]
}

enum GroupSortingType: Equatable, CaseIterable {
    case number
    case speciality
}

class GroupsViewModel: ObservableObject {
    
    @Published var groups: [Group] = []
    private var cancelable: AnyCancellable?
    
    @Published var sortedBy: GroupSortingType = .speciality
    
    init(groupPublisher: AnyPublisher<[Group], Never> = GroupStorage.shared.values.eraseToAnyPublisher()) {
        cancelable = groupPublisher.sink { groups in
            self.groups = groups
        }
    }
    
    func sections(_ searchText: String) -> [GroupSection] {
        let filitredGroups = groups.filter { group in
            searchText.isEmpty ||
            group.id!.localizedStandardContains(searchText) ||
            group.speciality!.abbreviation!.localizedStandardContains(searchText)
        }
        
        return sort(groups: filitredGroups)
    }
    
    private func sort(groups: [Group]) -> [GroupSection] {
        var sections: [GroupSection] = []
        
        switch sortedBy {
        case .number:
            var groupPrefixes = Set<String.SubSequence>()
            groups.map{$0.id!.prefix(3)}.forEach { subSequence in
                groupPrefixes.insert(subSequence)
            }
            
            groupPrefixes.sorted().forEach { prefixSequence in
                sections.append(GroupSection(title: String(prefixSequence),
                                             groups: groups.filter{$0.id!.prefix(3) == prefixSequence}))
            }
        case .speciality:
            SpecialityStorage.shared.values.value.forEach { speciality in
                let specialityGroups = groups.filter{$0.speciality! == speciality}
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
