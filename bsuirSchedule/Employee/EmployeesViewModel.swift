//
//  EmployeesViewModel.swift
//  EmployeesViewModel
//
//  Created by Andrej Hurynovič on 8.09.21.
//

import SwiftUI

class EmployeesViewModel: ObservableObject {
    
    func update() async {
        await Employee.fetchAll()
        let employees = Employee.getEmployees()
        await Employee.updatePhotos(for: employees)
//        await Employee.updateEmployees(employees: employees)
        await MainActor.run {
            try! PersistenceController.shared.container.viewContext.save()
        }
    }
    
}
