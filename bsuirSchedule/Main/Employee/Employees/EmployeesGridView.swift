//
//  EmployeesGridView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 5.04.23.
//

import SwiftUI

struct EmployeesGridView: View {
    var sections: [NSManagedObjectsSection<Employee>]
    
    var showDepartments: Bool
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 256, maximum: 512))],
                  alignment: .leading,
                  spacing: 8) {
            ForEach(sections, id: \.title) { section in
                Section {
                    ForEach(section.items) { employee in
                        NavigationLink {
                            EmployeeDetailedView(employee: employee)
                        } label: {
                            EmployeeView(employee: employee,
                                         showDepartments: showDepartments)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 16)
                                .fill(Color(uiColor: .secondarySystemGroupedBackground)))
                        }
                        .id("\(section.title):\(employee.id)")
                        .contextMenu {
                            FavoriteButton(item: employee)
                        }
                    }
                } header: {
                    HeaderView(section.title)
                }
            }
            
        }
                  .padding([.horizontal, .bottom])
    }
}

struct EmployeesGridView_Previews: PreviewProvider {
    static var previews: some View {
        let employees = Employee.getAll()
        
        ForEach(EmployeeSectionType.allCases, id: \.self) { sectionType in
            ScrollView {
                EmployeesGridView(sections: employees.sections(sectionType),
                                  showDepartments: true)
            }
            .background(Color(UIColor.systemGroupedBackground))
        }
    }
}
