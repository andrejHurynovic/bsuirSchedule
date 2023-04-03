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
        await Employee.updateEmployees(employees: Employee.getAll())
    }
    
    ///This method calculates a predicate to filter the list of Employees based on a search query. It takes a search query as an argument and returns an NSPredicate object. The predicate is constructed based on the search query and it filters Employees by their last name, first name, department name or department abbreviation. If the search query is empty, the method returns nil, which means that no filtering is needed.
    func calculatePredicate(_ searchText: String) -> NSPredicate? {
        guard !searchText.isEmpty else { return nil }
        return NSCompoundPredicate(orPredicateWithSubpredicates: [NSPredicate(format: "lastName BEGINSWITH[c] %@", searchText),
                                                                  NSPredicate(format: "firstName BEGINSWITH[c] %@", searchText),
                                                                  NSPredicate(format: "ANY departments.name CONTAINS[c] %@", searchText),
                                                                  NSPredicate(format: "ANY departments.abbreviation BEGINSWITH[c] %@", searchText)])
        
    }
    
}
