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
    
    init(groupPublisher: AnyPublisher<[Group], Never> = GroupStorage.shared.values.eraseToAnyPublisher()) {
        cancelable = groupPublisher.sink { groups in
            self.groups = groups
        }
    }
    
    func fetchGroups() {
        GroupStorage.shared.fetch()
    }
}
