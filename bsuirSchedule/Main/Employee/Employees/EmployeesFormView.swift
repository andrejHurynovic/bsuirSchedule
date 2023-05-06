//
//  EmployeesFormView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 5.05.23.
//

import SwiftUI

struct EmployeesFormView: View {
    var employees: [Employee]
    
    var body: some View {
        DisclosureGroup {
            ForEach(employees.sorted(by: { $0.lastName < $1.lastName })) { employee in
                NavigationLink {
                    EmployeeDetailedView(employee: employee)
                } label: {
                    EmployeeView(employee: employee,
                                 showDepartments: false)
                }
            }
        } label: {
            Label("Преподаватели", systemImage: Constants.Symbols.employees)
        }
    }
}

struct EmployeesFormView_Previews: PreviewProvider {
    static var previews: some View {
        let employees: [Employee] = Employee.getAll()
        NavigationView {
            Form {
                EmployeesFormView(employees: employees)
            }
        }
    }
}
