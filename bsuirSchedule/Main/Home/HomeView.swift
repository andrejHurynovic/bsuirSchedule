//
//  HomeView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 29.04.23.
//

import SwiftUI

struct HomeView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\Group.name)],
                  predicate: NSPredicate(format: "favorite = true"),
                  animation: .spring())
    var groups: FetchedResults<Group>
    @FetchRequest(sortDescriptors: [SortDescriptor(\Employee.lastName),
                                    SortDescriptor(\Employee.firstName),
                                    SortDescriptor(\Employee.middleName)],
                  predicate: NSPredicate(format: "favorite = true"),
                  animation: .spring())
    var employees: FetchedResults<Employee>
    @FetchRequest(sortDescriptors: [SortDescriptor(\Auditorium.building),
                                    SortDescriptor(\Auditorium.formattedName)],
                  predicate: NSPredicate(format: "favorite = true"),
                  animation: .spring())
    var auditories: FetchedResults<Auditorium>
    @FetchRequest(sortDescriptors: [SortDescriptor(\EducationTask.deadline, order: .forward)],
                  animation: .spring())
    var educationTasks: FetchedResults<EducationTask>
    
    @StateObject var primarySchedulesViewModel = PrimarySchedulesViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                primarySchedules
                
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
                educationTasksGrid
            }
            .navigationTitle("Избранные")
            .toolbar(content: {
                NavigationLink(destination: SettingsView()) {
                    Image(systemName: Constants.Symbols.configuration)
                        .toolbarCircle()
                }
            })
            
            .baseBackground()
        }
        .navigationViewStyle(.stack)

    }
    
    @ViewBuilder var primarySchedules: some View {
        if let primaryGroupName = primarySchedulesViewModel.primaryGroup,
           let primaryGroup = groups.first(where: { $0.name == primaryGroupName }) {
            PrimaryScheduleView(viewModel: PrimaryScheduleViewModel(scheduled: primaryGroup,
                                                                    subgroup: primarySchedulesViewModel.primaryGroupSubgroup))
        }
        if let primaryEmployeeID = primarySchedulesViewModel.primaryEmployee,
           let primaryEmployee = employees.first(where: { $0.id == primaryEmployeeID }) {
            PrimaryScheduleView(viewModel: PrimaryScheduleViewModel(scheduled: primaryEmployee))
        }
        if let primaryAuditoriumFormattedName = primarySchedulesViewModel.primaryAuditorium,
           let primaryAuditorium = auditories.first(where: { $0.formattedName == primaryAuditoriumFormattedName }) {
            PrimaryScheduleView(viewModel: PrimaryScheduleViewModel(scheduled: primaryAuditorium))
        }
    }
    
    @ViewBuilder var educationTasksGrid: some View {
        if educationTasks.isEmpty == false {
            LazyVGrid(columns: [SquareTextView.gridItem],
                      alignment: .leading,
                      spacing: 8) {
                Section {
                    ForEach(educationTasks, id: \.self) { educationTask in
                        EducationTaskNavigationLink(educationTask: educationTask)
                    }
                } header: {
                    HeaderView("Задания", withArrow: false)
                }
            }
                      .padding(.horizontal)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
