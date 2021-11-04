//
//  StorageTemplate.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 18.10.21.
//

import Foundation
import Combine
import CoreData

class Storage<T: NSManagedObject>: NSObject, NSFetchedResultsControllerDelegate, ObservableObject {
    var values = CurrentValueSubject<[T], Never>([])
    
    let fetchController: NSFetchedResultsController<T>
    var cancellables = Set<AnyCancellable>()
    
    init(sortDescriptors: [NSSortDescriptor]) {
        let request = T.fetchRequest()
        request.sortDescriptors = sortDescriptors
        fetchController = NSFetchedResultsController(fetchRequest: request,
                                                     managedObjectContext: PersistenceController.shared.container.viewContext,
                                                     sectionNameKeyPath: nil, cacheName: nil) as! NSFetchedResultsController<T>
        super.init()
        
        fetchController.delegate = self
        do {
            try fetchController.performFetch()
            values.value = fetchController.fetchedObjects ?? []
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
    
    func delete(_ value: T) {
        PersistenceController.shared.container.viewContext.delete(value)
        save()
    }
    
    func deleteAll() {
        values.value.forEach { value in
            PersistenceController.shared.container.viewContext.delete(value)
        }
        save()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let values = controller.fetchedObjects as? [T] else {return}
        
        self.values.value = values
    }
}
