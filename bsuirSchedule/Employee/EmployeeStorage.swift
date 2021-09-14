//
//  EmployeeStorage.swift
//  EmployeeStorage
//
//  Created by Andrej Hurynovič on 8.09.21.
//

import Foundation
import Combine
import CoreData

class EmployeeStorage: NSObject, ObservableObject {
    var employees = CurrentValueSubject<[Employee], Never>([])
    private let employeeFetchController: NSFetchedResultsController<Employee>
    
    static let shared: EmployeeStorage = EmployeeStorage()
    
    private override init() {
        employeeFetchController = NSFetchedResultsController(fetchRequest: Employee.fetchRequest(),
                                                             managedObjectContext: PersistenceController.shared.container.viewContext,
                                                             sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        
        employeeFetchController.delegate = self
        do {
            try employeeFetchController.performFetch()
            employees.value = employeeFetchController.fetchedObjects ?? []
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
    
    func delete(_ employee: Employee) {
        PersistenceController.shared.container.viewContext.delete(employee)
        save()
    }
    
    func deleteAll() {
        employees.value.forEach { employee in
            PersistenceController.shared.container.viewContext.delete(employee)
        }
        save()
    }
    
    func fetch() {
        URLSession(configuration: .default).dataTask(with: URL(string: "https://journal.bsuir.by/api/v1/employees")!) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                if let employees = try? decoder.decode([EmployeeModel].self, from: data) {
                    employees.forEach { employee in
                        _ = Employee(employee)
                    }
                    EmployeeStorage.shared.save()
                }
            }
        }.resume()
    }
}

extension EmployeeStorage: NSFetchedResultsControllerDelegate {
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let employees = controller.fetchedObjects as? [Employee] else {return}
        
        self.employees.value = employees
    }
}
