//
//  GroupStorage.swift
//  GroupStorage
//
//  Created by Andrej Hurynovič on 10.09.21.
//

import Foundation
import Combine
import CoreData

class GroupStorage: NSObject, ObservableObject {
    var groups = CurrentValueSubject<[Group], Never>([])
    private let groupFetchController: NSFetchedResultsController<Group>
    
    static let shared: GroupStorage = GroupStorage()
    
    private override init() {
        groupFetchController = NSFetchedResultsController(fetchRequest: Group.fetchRequest(),
                                                          managedObjectContext: PersistenceController.shared.container.viewContext,
                                                          sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        
        groupFetchController.delegate = self
        do {
            try groupFetchController.performFetch()
            groups.value = groupFetchController.fetchedObjects ?? []
        } catch {
            
        }
    }
    
    func save() {
        do {
            try PersistenceController.shared.container.viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func delete(_ group: Group) {
        PersistenceController.shared.container.viewContext.delete(group)
        save()
    }
    
    func deleteAll() {
        groups.value.forEach { group in
            PersistenceController.shared.container.viewContext.delete(group)
        }
        save()
    }
    
    func fetch() {
        URLSession(configuration: .default).dataTask(with: URL(string: "https://journal.bsuir.by/api/v1/groups")!) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                if let groups = try? decoder.decode([GroupModel].self, from: data) {
                    groups.forEach { group in
                        _ = Group(group)
                    }
                    GroupStorage.shared.save()
                }
            }
        }.resume()
    }
}

extension GroupStorage: NSFetchedResultsControllerDelegate {
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let groups = controller.fetchedObjects as? [Group] else {return}
        
        self.groups.value = groups
    }
}
