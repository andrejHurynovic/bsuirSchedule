//
//  DepartmentDetailedView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 5.05.23.
//

import SwiftUI

struct DepartmentDetailedView: View {
    @ObservedObject var department: Department
    
    var body: some View {
        List {
            nameSection
            links
        }
        .navigationTitle(department.abbreviation)
        
        .toolbar{ FavoriteButton(item: department) }
    }
    
    @ViewBuilder var nameSection: some View {
        if let name = department.name {
            Section("Название") {
                Text(name)
            }
        }
    }
    
    @ViewBuilder var links: some View {
        if[department.auditories != nil,
           department.employees != nil].contains(true) {
            Section("Ссылки") {
                auditories
                employees
            }
        }
    }
    
    @ViewBuilder var employees: some View {
        if let employees = department.employees?.allObjects as? [Employee],
           employees.isEmpty == false {
            EmployeesFormView(employees: employees)
        }
    }
    @ViewBuilder var auditories: some View {
        if let auditories = department.auditories?.allObjects as? [Auditorium],
           auditories.isEmpty == false {
            AuditoriesFormView(auditories: auditories)
        }
    }
}

struct DepartmentDetailedView_Previews: PreviewProvider {
    static var previews: some View {
        let departments: [Department] = Department.getAll()
        if let department = departments.first(where: { $0.abbreviation == "ЭВС" }) {
            NavigationView {
                DepartmentDetailedView(department: department)
            }
        }
    }
}
