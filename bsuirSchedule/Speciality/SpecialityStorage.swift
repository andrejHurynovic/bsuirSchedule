//
//  SpecialityStorage.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 15.10.21.
//

import Foundation
import Combine
import CoreData

class SpecialityStorage: NSObject, ObservableObject {
    var specialities = CurrentValueSubject<[Speciality], Never>([])
    private let specialityFetchController: NSFetchedResultsController<Speciality>
    private var cancellables = Set<AnyCancellable>()

    static let shared: SpecialityStorage = SpecialityStorage()
    
    
    
    private override init() {
        specialityFetchController = NSFetchedResultsController(fetchRequest: Speciality.fetchRequest(),
                                                          managedObjectContext: PersistenceController.shared.container.viewContext,
                                                          sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        
        specialityFetchController.delegate = self
        do {
            try specialityFetchController.performFetch()
            specialities.value = specialityFetchController.fetchedObjects ?? []
        } catch {
            
        }
    }
    
    func fetch() {
        let url = URL(string: "https://journal.bsuir.by/api/v1/specialities")!
        URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .tryMap { (data, response) -> Data in
                guard let response = response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300 else {
                          throw URLError(.badServerResponse)
                      }
                return data
            }
            .decode(type: [Speciality].self, decoder: JSONDecoder())
            .sink { completion in
            } receiveValue: { (_) in
                SpecialityStorage.shared.save()
            }
            .store(in: &cancellables)
    }
    
    func save() {
        try! PersistenceController.shared.container.viewContext.save()
    }
    
    func delete(_ speciality: Speciality) {
        PersistenceController.shared.container.viewContext.delete(speciality)
        save()
    }
    
    func deleteAll() {
        specialities.value.forEach { speciality in
            PersistenceController.shared.container.viewContext.delete(speciality)
        }
        save()
    }
}

extension SpecialityStorage: NSFetchedResultsControllerDelegate {
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let specialities = controller.fetchedObjects as? [Speciality] else {return}
        
        self.specialities.value = specialities
    }
}
