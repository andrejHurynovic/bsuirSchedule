//
//  EmployeeStorage.swift
//  EmployeeStorage
//
//  Created by Andrej Hurynovič on 8.09.21.
//

import Foundation
import Combine
import CoreData
import UIKit

class EmployeeStorage: NSObject, ObservableObject {
    var employees = CurrentValueSubject<[Employee], Never>([])
    
    private let employeeFetchController: NSFetchedResultsController<Employee>
    private var cancellables = Set<AnyCancellable>()
    
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
        let url = URL(string: "https://journal.bsuir.by/api/v1/employees")!
        URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .tryMap { (data, response) -> Data in
                guard let response = response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300 else {
                          throw URLError(.badServerResponse)
                      }
                return data
            }
            .decode(type: [EmployeeModel].self, decoder: JSONDecoder())
            .sink { completion in
            } receiveValue: { (returnedEmployees) in
                returnedEmployees.forEach { employee in
                    _ = Employee(employee)
                }
                EmployeeStorage.shared.save()
                EmployeeStorage.shared.fetchPhotos()
            }
            .store(in: &cancellables)
    }
    
    func update(_ employee: Employee) {
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 100
        let url = URL(string:  "https://journal.bsuir.by/api/v1/portal/employeeSchedule?employeeId=" + String(employee.id))!
        
        URLSession(configuration: config).dataTaskPublisher(for: url).share()
            .receive(on: DispatchQueue.main)
            .tryMap { (data, response) -> Data in
                guard let response = response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300 else {
                          throw URLError(.badServerResponse)
                      }
                return data
            }
            .decode(type: EmployeeModel.self, decoder: JSONDecoder())
            .sink { completion in
            } receiveValue: { (updatedEmployee) in
//                updatedEmployee.lessons.forEach { lesson in
//                    lesson.employee = EmployeeStorage.shared.employees.value.first(where: {$0.id == lesson.employeeID})
//                }
                employee.update(updatedEmployee)
                EmployeeStorage.shared.save()
            }
            .store(in: &cancellables)
    }
    
    func fetchPhotos() {
        employees.value.forEach { employee in
            fetchPhoto(of: employee)
        }
    }
    
    func fetchPhoto(of employee: Employee) {
        let url = URL(string: employee.photoLink!)!
        URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .tryMap { (data, response) -> Data in
                guard let response = response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300 else {
                          throw URLError(.badServerResponse)
                      }
                return data
            }
            .sink { completion in
            } receiveValue: { (data) in
                employee.photo = data
                EmployeeStorage.shared.save()
            }
            .store(in: &cancellables)
    }
}

extension EmployeeStorage: NSFetchedResultsControllerDelegate {
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let employees = controller.fetchedObjects as? [Employee] else {return}
        
        self.employees.value = employees
    }
}
