//
//  EmployeeExtensions.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 1.05.23.
//

import Foundation

extension Employee: Identifiable { }
extension Employee: Favored { }

extension Employee: EducationBounded { }
extension Employee: EducationRanged { }

extension Employee: Scheduled {
    var title: String { self.lastName }
}

//MARK: - Group

extension Group {
    var employees: [Employee]? {
        guard let lessons = self.lessons?.allObjects as? [Lesson] else { return nil }
        
        let employees = Set(lessons.compactMap { $0.employees?.allObjects as? [Employee] }
            .flatMap { $0 })
            .sorted { $0.lastName < $1.lastName }
        
        guard employees.isEmpty == false else { return nil }
        return employees
    }
    
}

//MARK: - Other

extension Employee {
    var formattedName: String {
        var formattedName = firstName
        if let lastName = self.middleName {
            formattedName.append(" \(lastName)")
        }
        return formattedName
    }
    
    var departmentsArray: [Department]? {
        guard let departments = departments?.allObjects as? [Department] else {
            return nil
        }
        return departments
    }
    var departmentsAbbreviations: [String]? {
        guard let departments = departmentsArray else {
            return nil
        }
        return departments.map { $0.abbreviation }
    }
}
