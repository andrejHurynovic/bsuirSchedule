//
//  GroupsViewModel.swift
//  GroupsViewModel
//
//  Created by Andrej Hurynovič on 11.09.21.
//

import SwiftUI
import Combine

class GroupsViewModel: ObservableObject {
    @Published var groups: [Group] = []
    
    private var cancelable: AnyCancellable?
    
    init(groupPublisher: AnyPublisher<[Group], Never> = GroupStorage.shared.groups.eraseToAnyPublisher()) {
        cancelable = groupPublisher.sink { groups in
            self.groups = groups
        }
    }
    
    func foundGroups(_ searchText: String) -> [Group] {
        groups.filter {group in
            searchText.isEmpty ||
            (group.id?.localizedStandardContains(searchText) ?? true) ||
            (group.speciality?.abbreviation?.localizedStandardContains(searchText) ?? true)
        }
    }
    
    func fetchGroups() {
        GroupStorage.shared.fetchBasic()
    }
    
    func updateGroup() {
        
    }
}
