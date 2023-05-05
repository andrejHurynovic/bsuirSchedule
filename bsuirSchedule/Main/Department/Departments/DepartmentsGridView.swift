//
//  DepartmentsGridView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 5.05.23.
//

import SwiftUI

struct DepartmentsGridView: View {
    var departments: [Department]
    
    var body: some View {
        SquareGrid {
            ForEach(departments) { department in
                DepartmentNavigationLink(department: department)
            }
        }
        .padding([.horizontal, .bottom])
    }
}

struct DepartmentsGridView_Previews: PreviewProvider {
    static var previews: some View {
        let departments: [Department] = Department.getAll()
        
        DepartmentsGridView(departments: departments)
    }
}
