//
//  DepartmentNavigationLink.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 5.05.23.
//

import SwiftUI

struct DepartmentNavigationLink: View {
    @ObservedObject var department: Department
    
    var body: some View {
        NavigationLink {
            DepartmentDetailedView(department: department)
        } label: {
            
            SquareTextView(title: department.abbreviation,
                           firstSubtitle: auditoriesString,
                           secondSubtitle: employeesString)
        }
        .contextMenu {
            FavoriteButton(item: department)
        }
    }
    
    var auditoriesString: String? {
        guard let auditories = department.auditories,
              auditories.count != 0 else { return nil }
        return "Ауд.: \(auditories.count)"
        
    }
    var employeesString: String? {
        guard let employees = department.employees,
              employees.count != 0 else { return nil }
        return "Преп.: \(employees.count)"
    }
}
