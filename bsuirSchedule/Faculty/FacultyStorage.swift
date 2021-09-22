//
//  FacultyStorage.swift
//  FacultyStorage
//
//  Created by Andrej Hurynovič on 21.09.21.
//

import Foundation
import Combine
import CoreData

class FacultyStorage: NSObject, ObservableObject {
    var faculties = CurrentValueSubject<[Faculty], Never>([])
    private let facultyFetchController: NSFetchedResultsController<Faculty>
    private var cancellables = Set<AnyCancellable>()

    static let shared: FacultyStorage = FacultyStorage()
    
    
    
    private override init() {
        facultyFetchController = NSFetchedResultsController(fetchRequest: Faculty.fetchRequest(),
                                                          managedObjectContext: PersistenceController.shared.container.viewContext,
                                                          sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        
        facultyFetchController.delegate = self
        do {
            try facultyFetchController.performFetch()
            faculties.value = facultyFetchController.fetchedObjects ?? []
        } catch {
            
        }
    }
    
    func fetch() {
        let url = URL(string: "https://journal.bsuir.by/api/v1/faculties")!
        URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .tryMap { (data, response) -> Data in
                guard let response = response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300 else {
                          throw URLError(.badServerResponse)
                      }
                return data
            }
            .decode(type: [Faculty].self, decoder: JSONDecoder())
            .sink { completion in
            } receiveValue: { (_) in
                FacultyStorage.shared.save()
            }
            .store(in: &cancellables)
    }
    
    func save() {
        try! PersistenceController.shared.container.viewContext.save()
    }
    
    func delete(_ faculty: Faculty) {
        PersistenceController.shared.container.viewContext.delete(faculty)
        save()
    }
    
    func deleteAll() {
        faculties.value.forEach { faculty in
            PersistenceController.shared.container.viewContext.delete(faculty)
        }
        save()
    }
}

extension FacultyStorage: NSFetchedResultsControllerDelegate {
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let faculties = controller.fetchedObjects as? [Faculty] else {return}
        
        self.faculties.value = faculties
    }
}
