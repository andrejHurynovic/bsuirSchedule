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
    
    init(groupPublisher: AnyPublisher<[Group], Never> = GroupStorage.shared.groups.eraseToAnyPublisher()) {
        cancelable = groupPublisher.sink { groups in
            self.groups = groups
        }
    }
    
    func foundGroups(_ searchText: String) -> [GroupSection] {
        var sections: [GroupSection] = []
        
        switch sortedBy {
        case .number:
            var groupPrefixes = Set<String.SubSequence>()
            groups
                .filter { group in
                    searchText.isEmpty ||
                    (group.id?.localizedStandardContains(searchText) ?? true) ||
                    (group.speciality?.abbreviation?.localizedStandardContains(searchText) ?? true)
                }
                .map{ $0.id!.prefix(3)}.forEach { subSequence in
                    groupPrefixes.insert(subSequence)
                }
            
            groupPrefixes.sorted().forEach { prefixSequence in
                sections.append(GroupSection(title: String(prefixSequence),
                                             groups: groups.filter{$0.id!.prefix(3) == prefixSequence}))
            }
            break
        case .speciality:
            SpecialityStorage.shared.specialities.value.forEach { speciality in
                let groups: [Group] = (speciality.groups?.allObjects as! [Group])
                    .sorted(by: {$0.id < $1.id})
                    .filter { group in
                        searchText.isEmpty ||
                        (group.id?.localizedStandardContains(searchText) ?? true) ||
                        (group.speciality?.abbreviation?.localizedStandardContains(searchText) ?? true)
                    }
                
                if groups.isEmpty == false {
                    sections.append(GroupSection(
                        title: "\(speciality.name!) (\(speciality.getEducationTypeDescription()), \(speciality.faculty!.abbreviation!))" ,
                        groups: groups))
                }
            }
        }
        return sections
    }
    
    func fetchGroups() {
        GroupStorage.shared.fetchBasic()
    }
}



struct GroupSection: Hashable {
    var title: String
    var groups: [Group]
}
