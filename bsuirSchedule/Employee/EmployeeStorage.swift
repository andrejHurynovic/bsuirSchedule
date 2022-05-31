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
        cancellables.insert(FetchManager.shared.fetch(dataType: .employees, completion: {(employees: [Employee]) -> () in
            self.save()
            self.fetchAllPhotos()
            self.fetchAllDetailed()
        }))
    }
    
    func fetchAllDetailed() {
        self.values.value.forEachInout { employee in
            if employee.lessons?.count == 0 || employee.educationStart == nil {
                update(employee)
            }
        }
        self.save()
    }
    
    func update(_ employee: Employee) {
        if employee.educationStart == nil, employee.examsStart == nil {
            cancellables.insert(FetchManager.shared.fetch(dataType: .employee, argument: String(employee.id), completion: {(fetchedEmployee: Employee) -> () in
                if let lessons = fetchedEmployee.lessons {
                    employee.addToLessons(lessons)
                }
                employee.educationStart = fetchedEmployee.educationStart
                employee.educationEnd = fetchedEmployee.educationEnd
                employee.examsStart = fetchedEmployee.examsStart
                employee.examsEnd = fetchedEmployee.examsEnd
                employee.updateDate = Date()
                self.save()
            }))
        }
    }
    
    func fetchAllPhotos() {
        self.values.value.forEachInout { employee in
            if employee.photo == nil {
                fetchPhoto(employee)
            }
            self.save()
        }
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
