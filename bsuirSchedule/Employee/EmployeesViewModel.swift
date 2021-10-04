//
//  EmployeesViewModel.swift
//  EmployeesViewModel
//
//  Created by Andrej Hurynovič on 8.09.21.
//

import SwiftUI
import Combine

class EmployeesViewModel: ObservableObject {
    @Published var employees: [Employee] = []
    
    private var cancelable: AnyCancellable?
    
    init(employeePublisher: AnyPublisher<[Employee], Never> = EmployeeStorage.shared.employees.eraseToAnyPublisher()) {
        cancelable = employeePublisher.sink { employees in
            self.employees = employees
        }
    }
    
    func foundEmployees(_ searchText: String) -> [Employee] {
        employees.filter {employee in
            searchText.isEmpty || employee.lastName!.localizedStandardContains(searchText) || employee.departments!.contains(where: { department in
                department.localizedStandardContains(searchText)
            })
        }
    }

    func fetchEmployees() {
        EmployeeStorage.shared.fetch()
    }
    
    func updateEmployees() {
        
    }
}
