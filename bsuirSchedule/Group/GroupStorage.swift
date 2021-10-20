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
        cancellables.insert(FetchManager.shared.fetch(dataType: .groups, completion: {(groups: [Group]) -> () in
            self.save()
            self.fetchAllDetailed()
        }))
    }
    
    func fetchAllDetailed() {
        self.values.value.forEach { group in
            fetchDetailed(group, multipleFetch: true)
        }
        self.save()
    }
    
    func fetchDetailed(_ group: Group, multipleFetch: Bool = false) {
        cancellables.insert(FetchManager.shared.fetch(dataType: .group, argument: group.id, completion: {(fetchedGroup: Group) -> () in
            if let lessons = fetchedGroup.lessons {
                group.addToLessons(lessons)
            }
            group.educationStart = fetchedGroup.educationStart
            group.educationEnd = fetchedGroup.educationEnd
            
            self.delete(fetchedGroup)
        }))
        if multipleFetch == false {
            self.save()
        }
    }
}
