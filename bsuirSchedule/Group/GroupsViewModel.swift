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
            searchText.isEmpty || group.id?.localizedStandardContains(searchText) ?? true
        }
    }
    
    func fetchGroup(_ groupID: String) {
        URLSession(configuration: .default).dataTask(with: URL(string: "https://journal.bsuir.by/api/v1/studentGroup/schedule?studentGroup=" + groupID)!) { data, response, error in
            if let data = data {
                if !data.isEmpty {
                    let group = self.groups.first(where: {$0.id == groupID})!
                    let decoder = JSONDecoder()
                    if let groupUpdate = try? decoder.decode(GroupModel.self, from: data) {
                        groupUpdate.lessons.forEach { lesson in
                            lesson.employee = EmployeeStorage.shared.employees.value.first(where: {$0.id == lesson.employeeID})
                        }
                        group.removeFromLessons(group.lessons!)
                        group.addToLessons(NSSet(array: groupUpdate.lessons))
                        GroupStorage.shared.save()
                    }
                }
            }
        }.resume()
    }
    
    func fetchGroups() {
        GroupStorage.shared.fetch()
    }
    
    func updateGroup() {
        
    }
}
