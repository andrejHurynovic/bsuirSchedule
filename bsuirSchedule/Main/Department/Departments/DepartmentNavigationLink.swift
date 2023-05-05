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
            SquareView(title: department.abbreviation)
        }
        .contextMenu {
            FavoriteButton(item: department)
        }
    }
}
