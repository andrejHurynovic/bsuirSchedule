//
//  GroupStorage.swift
//  GroupStorage
//
//  Created by Andrej Hurynovič on 10.09.21.
//

import Foundation

class GroupStorage: Storage<Group> {
    
    static let shared = GroupStorage(sortDescriptors: [NSSortDescriptor(keyPath: \Group.id, ascending: true)])
    
    func fetch() {
        cancellables.insert(FetchManager.shared.fetch(dataType: .groups, completion: {(groups: [GroupModel]) -> () in
            groups.forEach { group in
                self.fetchDetailed(Group(group))
            }
            self.save()
        }))
    }
    
    func fetchDetailed(_ group: Group) {
        cancellables.insert(FetchManager.shared.fetch(dataType: .group, argument: group.id!, completion: {(fetchedGroup: GroupModel) -> () in
            fetchedGroup.lessons.forEach { lesson in
                lesson.employee = EmployeeStorage.shared.values.value.first(where: {$0.id == lesson.employeeID})
            }
            group.update(fetchedGroup)
            self.save()
        }))
    }
}
