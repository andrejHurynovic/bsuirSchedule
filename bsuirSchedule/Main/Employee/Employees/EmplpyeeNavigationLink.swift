//
//  EmployeeNavigationLink.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 30.04.23.
//

import SwiftUI

struct EmployeeNavigationLink: View {
    @ObservedObject var employee: Employee
    
    var showDepartments: Bool
    
    var body: some View {
        NavigationLink {
            ScheduleView(scheduled: employee)
        } label: {
            EmployeeView(employee: employee,
                         showDepartments: showDepartments)
            .padding()
            .roundedRectangleBackground()
        }
        .contextMenu {
            FavoriteButton(item: employee)
        }
    }
}
