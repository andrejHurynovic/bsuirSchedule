//
//  ClassroomStorage.swift
//  ClassroomStorage
//
//  Created by Andrej Hurynovič on 25.09.21.
//

import Foundation
import Combine
import CoreData
import UIKit

class ClassroomStorage: NSObject, ObservableObject {
    var classrooms = CurrentValueSubject<[Classroom], Never>([])
    
    private let classroomFetchController: NSFetchedResultsController<Classroom>
    private var cancellables = Set<AnyCancellable>()
    
    static let shared: ClassroomStorage = ClassroomStorage()
    
    
    
    private override init() {
        classroomFetchController = NSFetchedResultsController(fetchRequest: Classroom.fetchRequest(),
                                                             managedObjectContext: PersistenceController.shared.container.viewContext,
                                                             sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        
        classroomFetchController.delegate = self
        do {
            try classroomFetchController.performFetch()
            classrooms.value = classroomFetchController.fetchedObjects ?? []
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
    
    func delete(_ classroom: Classroom) {
        PersistenceController.shared.container.viewContext.delete(classroom)
        save()
    }
    
    func deleteAll() {
        classrooms.value.forEach { classroom in
            PersistenceController.shared.container.viewContext.delete(classroom)
        }
        save()
    }
    
    func fetch() {
        let url = URL(string: "https://journal.bsuir.by/api/v1/auditory")!
        URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .tryMap { (data, response) -> Data in
                guard let response = response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300 else {
                          throw URLError(.badServerResponse)
                      }
                return data
            }
            .decode(type: [ClassroomModel].self, decoder: JSONDecoder())
            .sink { completion in
            } receiveValue: { (returnedClassrooms) in
                returnedClassrooms.filter({(1...7).contains($0.building)}) .forEach { classroom in
                    let newClassroom = Classroom(classroom)
                    if (6...7).contains(classroom.building) {
                        newClassroom.building += 1
                    }
                }
                ClassroomStorage.shared.save()
            }
            .store(in: &cancellables)
    }
    
    func classroom(name: String) -> Classroom? {
        var name = name
        let range = name.range(of: "к.")!
        name.removeSubrange(range)
        name = name.trimmingCharacters(in: .whitespaces)
        
        let separator = name.lastIndex(of: "-")!
        let classroom = classrooms.value.first { $0.name! == name.prefix(upTo: separator) && $0.building == Int(String(name.last!))! }
        
        return classroom
    }
}

extension ClassroomStorage: NSFetchedResultsControllerDelegate {
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let classrooms = controller.fetchedObjects as? [Classroom] else {return}
        
        self.classrooms.value = classrooms
    }
}
