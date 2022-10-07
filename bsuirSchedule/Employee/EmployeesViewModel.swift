//
//  EmployeesViewModel.swift
//  EmployeesViewModel
//
//  Created by Andrej Hurynovič on 8.09.21.
//

import SwiftUI
import Combine
import CoreData

class EmployeesViewModel: ObservableObject {
    
    func foundEmployees(employees: FetchedResults<Employee>, _ searchText: String) -> [Employee] {
        employees.filter {employee in
            searchText.isEmpty || employee.lastName!.localizedStandardContains(searchText) || employee.departments!.contains(where: { department in
                department.localizedStandardContains(searchText)
            })
        }
    }
    
    func updateAll() async {
        await Employee.fetchAllEmployees()
        let employees = Employee.getEmployees()
        await Employee.updatePhotos(for: employees)
//        await Employee.updateEmployees(employees: employees)
        await MainActor.run {
            try! PersistenceController.shared.container.viewContext.save()
        }
    }
}


extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}
