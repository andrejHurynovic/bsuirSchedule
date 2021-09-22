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
    private var cancellables = Set<AnyCancellable>()
    
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
    
    func fetchBasic() {
        let url = URL(string: "https://journal.bsuir.by/api/v1/groups")!
        URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .tryMap { (data, response) -> Data in
                guard let response = response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300 else {
                          throw URLError(.badServerResponse)
                      }
                return data
            }
            .decode(type: [GroupModel].self, decoder: JSONDecoder())
            .sink { completion in
            } receiveValue: { (returnedGroups) in
                returnedGroups.forEach { group in
                    _ = Group(group)
                }
                GroupStorage.shared.save()
                GroupStorage.shared.allGroups()
            }
            .store(in: &cancellables)
    }
    
    func allGroups() {
        groups.value.forEach { group in
            update(group)
        }
    }
    
    func update(_ group: Group) {
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 100
        let url = URL(string: "https://journal.bsuir.by/api/v1/studentGroup/schedule?studentGroup=" + group.id!)!
        
        URLSession(configuration: config).dataTaskPublisher(for: url).share()
            .receive(on: DispatchQueue.main)
            .tryMap { (data, response) -> Data in
                guard let response = response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300 else {
                          throw URLError(.badServerResponse)
                      }
                return data
            }
            .decode(type: GroupModel.self, decoder: JSONDecoder())
            .sink { completion in
            } receiveValue: { (updatedGroup) in
                updatedGroup.lessons.forEach { lesson in
                    lesson.employee = EmployeeStorage.shared.employees.value.first(where: {$0.id == lesson.employeeID})
                }
                group.update(updatedGroup)
                GroupStorage.shared.save()
            }
            .store(in: &cancellables)
    }
}

extension GroupStorage: NSFetchedResultsControllerDelegate {
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let groups = controller.fetchedObjects as? [Group] else {return}
        
        self.groups.value = groups
    }
}
