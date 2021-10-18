//
//  EmployeeStorage.swift
//  EmployeeStorage
//
//  Created by Andrej Hurynovič on 8.09.21.
//

import Foundation

class EmployeeStorage: Storage<Employee> {
    
    static let shared: EmployeeStorage = EmployeeStorage(
        sortDescriptors: [NSSortDescriptor(keyPath: \Employee.lastName, ascending: true),
                          NSSortDescriptor(keyPath: \Employee.firstName, ascending: true)])
    
    func fetch() {
        cancellables.insert(FetchManager.shared.fetch(dataType: .employees, completion: {(employees: [EmployeeModel]) -> () in
            employees.forEach { employee in
                _ = Employee(employee)
            }
            self.save()
            self.values.value.forEach { employee in
                self.fetchPhoto(employee)
            }
        }))
    }
    
    func fetchDetailed(_ employee: Employee) {
        cancellables.insert(FetchManager.shared.fetch(dataType: .employee, argument: String(employee.id), completion: {(fetchedEmployee: EmployeeModel) -> () in
            employee.update(fetchedEmployee)
            self.save()
        }))
    }
    
    func fetchPhoto(_ employee: Employee) {
            URLSession.shared.dataTaskPublisher(for: URL(string: employee.photoLink!)!)
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
                    self.save()
                }
                .store(in: &cancellables)
    }
}
