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
                HomeViewGrid(items: Array(educationTasks), navigationLinkTitle: "Задания", navigationLinkDestination: EmptyView()) { educationTask in
                    NavigationLink {
                        EducationTaskDetailedView(viewModel: EducationTaskDetailedViewModel(educationTask: educationTask))
                    } label: {
                        SquareTextView(title: educationTask.subject, firstSubtitle: educationTask.note, secondSubtitle: educationTask.deadline?.formatted(.relative(presentation: .numeric, unitsStyle: .abbreviated)))
                    }

                   
                }
            }
                        .navigationTitle("Избранные")
            .toolbar(content: {
                NavigationLink(destination: SettingsView()) {
                    Image(systemName: Constants.Symbols.configuration)
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
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
