//
//  EmployeesSections.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 4.04.23.
//

import CoreData

extension Array where Element == Employee {
    func sections(_ type: EmployeeSectionType) -> [NSManagedObjectsSection<Employee>] {
        switch type {
            case .firstLetter:
                return self.sectioned(by: \.lastName.first!)
                    .sorted { $0.key < $1.key }
                    .map { NSManagedObjectsSection(title: String($0.key),
                                                   items: $0.value) }
            case .department:
                return departmentSections()
            case .rank:
                return self.sectioned(by: \.rank)
//                    .sorted {
//                        if $1.key == nil && $0.key != nil { return true }
//                        if $0.key == nil && $1.key != nil { return false }
//                        return $0.key! < $1.key!
//                    }
                    .sorted { $0.key ?? "" < $1.key ?? "" }
                    .map { NSManagedObjectsSection(title: $0.key ?? "Без ранга",
                                                   items: $0.value) }
            case .degree:
                return self.sectioned(by: \.degree)
                    .sorted { $0.key ?? "" < $1.key ?? "" }
                    .map { NSManagedObjectsSection(title: $0.key ?? "Без степени",
                                                   items: $0.value) }
        }
    }
    
    private func departmentSections() -> [NSManagedObjectsSection<Employee>] {
        let departments = Department.getAll()
        var sections: [NSManagedObjectsSection<Employee>] = departments.compactMap { department in
            
            let employees = self.filter { employee in
                if let departments = employee.departments, departments.contains(department) {
                    return true
                } else {
                    return false
                }
            }
            guard employees.isEmpty == false else { return nil }
            
            return NSManagedObjectsSection(title: department.abbreviation,
                                           items: employees)
        }
        
        
        let noDepartmentsEmployees = self.filter( { $0.departmentsArray == nil } )
        if noDepartmentsEmployees.isEmpty == false {
            sections.append( NSManagedObjectsSection(title: "Без подразделения",
                                                     items: noDepartmentsEmployees))
        }
        
        return sections
    }
    
}

