//
//  HomeView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 29.04.23.
//

import SwiftUI

struct HomeView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\Group.name)],
                  predicate: NSPredicate(format: "favroite = true"),
                  animation: .spring())
    var groups: FetchedResults<Group>
    @FetchRequest(sortDescriptors: [SortDescriptor(\Employee.lastName),
                                    SortDescriptor(\Employee.firstName),
                                    SortDescriptor(\Employee.middleName)],
                  predicate: NSPredicate(format: "favroite = true"),
                  animation: .spring())
    var employees: FetchedResults<Employee>
    @FetchRequest(sortDescriptors: [SortDescriptor(\Auditorium.formattedName)],
                  predicate: NSPredicate(format: "favroite = true"),
                  animation: .spring())
    var auditories: FetchedResults<Auditorium>
    
    var body: some View {
        NavigationView {
            ScrollView {
                HomeViewGrid(items: Array(groups),
                             navigationLinkTitle: "Группы",
                             navigationLinkDestination: GroupsView()) { group in
                    GroupNavigationLink(group: group)
                }
                HomeViewGrid(items: Array(employees),
                             gridItem: EmployeeView.gridItem,
                             navigationLinkTitle: "Преподаватели",
                             navigationLinkDestination: EmployeesView()) { employee in
                    EmployeeNavigationLink(employee: employee,
                                           showDepartments: false)
                }
                HomeViewGrid(items: Array(auditories),
                             navigationLinkTitle: "Аудитории",
                             navigationLinkDestination: AuditoriesView()) { auditorium in
                    AuditoriumNavigationLink(auditorium: auditorium)
                }
            }
            .navigationTitle("Избранные")
            .toolbar(content: {
                NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gear")
                }
            })
            
            .baseBackground()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
