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
    var style: NavigationLinkStyle = .grid
    
    var body: some View {
        NavigationLink {
            ScheduleView(scheduled: employee)
        } label: {
            switch style {
                case .grid:
                    EmployeeView(employee: employee,
                                 showDepartments: showDepartments)
                    .padding()
                    .roundedRectangleBackground()
                case .form:
                    EmployeeView(employee: employee,
                                 showDepartments: false)
            }
            
        }
        .contextMenu {
            FavoriteButton(item: employee)
            CompoundScheduleButton(item: employee)
        }
    }
}
