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
    
    func fetch() {
        URLSession(configuration: .default).dataTask(with: URL(string: "https://journal.bsuir.by/api/v1/faculties")!) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                _ = try decoder.decode([Faculty].self, from: data)
                } catch {
                    
                }
                FacultyStorage.shared.save()
            }
        }.resume()
    }
}

extension FacultyStorage: NSFetchedResultsControllerDelegate {
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let faculties = controller.fetchedObjects as? [Faculty] else {return}
        
        self.faculties.value = faculties
    }
}
