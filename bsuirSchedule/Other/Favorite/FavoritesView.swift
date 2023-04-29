//
//  FavoritesView.swift
//  FavoritesView
//
//  Created by Andrej Hurynovič on 21.09.21.
//

import SwiftUI

class FavouriteViewModel: ObservableObject {
    @AppStorage("primaryGroup") var primaryGroupID: String?
    @State var groupSection: ScheduleSection?
    @AppStorage("primaryEmployee") var primaryEmployeeID: Int?
    @State var employeeSection: ScheduleSection?
    @AppStorage("primaryAuditorium") var primaryAuditoriumID: String?
    @State var auditoriumSection: ScheduleSection?
}

struct FavoritesView: View {
    
    @ObservedObject var viewModel = FavouriteViewModel()
    
    @FetchRequest(
        entity: Group.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Group.name, ascending: true)],
        predicate:
            NSPredicate(format: "favroite = true"))
    var favouriteGroups: FetchedResults<Group>
    @FetchRequest(
        entity: Employee.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Employee.lastName, ascending: true),
            NSSortDescriptor(keyPath: \Employee.firstName, ascending: true)],
        predicate: NSPredicate(format: "favroite = true"))
    var favouriteEmployees: FetchedResults<Employee>
    @FetchRequest(
        entity: Auditorium.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Auditorium.outsideUniversity, ascending: true),
                          NSSortDescriptor(keyPath: \Auditorium.building, ascending: true),
                          NSSortDescriptor(keyPath: \Auditorium.floor, ascending: true),
                          NSSortDescriptor(keyPath: \Auditorium.name, ascending: true)],
        predicate:
            NSPredicate(format: "favroite = true"))
    var favouriteAuditories: FetchedResults<Auditorium>
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
//                    primaryGroup
//                    primaryEmployee
//                    primaryAuditorium
                }
                .padding(.horizontal)
                .transition(.move(edge: .leading))
                squareObjects
                rectangleObjects
            }
            .navigationTitle("Избранные")
        }
        .navigationViewStyle(.automatic)
    }
    
//    @ViewBuilder var primaryGroup: some View {
//        if let primaryGroupID = viewModel.primaryGroupID, let group = favouriteGroups.first(where: { $0.id == primaryGroupID }) {
//            VStack(alignment: .leading) {
//                FavoriteSectionView(viewModel: FavoriteSectionViewModel(lessonsSectioned: group))
//            }
//        }
//    }
//    @ViewBuilder var primaryEmployee: some View {
//        if let primaryEmployeeID = viewModel.primaryEmployeeID, let employee = favouriteEmployees.first(where: { $0.id == primaryEmployeeID }) {
//            FavoriteSectionView(viewModel: FavoriteSectionViewModel(lessonsSectioned: employee))
//            }
//        }
//    
//    @ViewBuilder var primaryAuditorium: some View {
//        if let primaryAuditoriumID = viewModel.primaryAuditoriumID, let auditorium = favouriteAuditories.first(where: { $0.formattedName == primaryAuditoriumID }) {
//            FavoriteSectionView(viewModel: FavoriteSectionViewModel(lessonsSectioned: auditorium))
//        }
//    }
    
    //MARK: - Grids
    
    @ViewBuilder var squareObjects: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 104, maximum: 500))], alignment: .leading, spacing: 8, pinnedViews: [.sectionHeaders]) {
//            tasks
            groups
            auditories
        }
        .padding([.leading, .horizontal, .top])
    }
    
    @ViewBuilder var rectangleObjects: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 240, maximum: 500))], alignment: .leading, spacing: 8, pinnedViews: [.sectionHeaders]) {
            employees
        }
        .padding(.horizontal)
    }
    
    //MARK: - Objects
    
//    @ViewBuilder var tasks: some View {
//        if viewModel.tasks.isEmpty == false {
//            Section {
//                ForEach(viewModel.tasks) { task in
//                    NavigationLink {
//                        TaskDetailedView()
//                            .environmentObject(TaskViewModel(task: task))
//                    } label: {
//                        TaskView(task: task)
//                    }
//                    .contextMenu {
//                        Button(role: .destructive) {
//                            withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.9)) {
//                                TaskStorage.shared.delete(task)
//                            }
//                        } label: {
//                            Label("Удалить", systemImage: "trash")
//                        }
//
//                    }
//
//                }
//            } header: {
//                HeaderView("Задания")
//                    .transition(.scale)
//            }
//        }
//
//    }
    
    @ViewBuilder var groups: some View {
        if favouriteGroups.isEmpty == false {
            Section {
                ForEach(favouriteGroups) { group in
                    NavigationLink {
                        ScheduleView(scheduled: group)
                    } label: {
                        FavoriteGroupView(group: group)
                    }
                    .contextMenu {
                        FavoriteButton(item: group)
                    }
                    
                }
            } header: {
                HeaderView("Группы")
                    .transition(.scale)
            }
        }
        
    }
    
    @ViewBuilder var employees: some View {
        if favouriteEmployees.isEmpty == false {
            Section {
                ForEach(favouriteEmployees) { employee in
                    NavigationLink {
                        ScheduleView(scheduled: employee)
                    } label: {
                        EmployeeFavoriteView(employee: employee)
                    }
                    .contextMenu {
                        FavoriteButton(item: employee)
                    }
                    
                }
            } header: {
                HeaderView("Преподаватели")
                    .transition(.scale)
            }
        }
    }
    @ViewBuilder var auditories: some View {
        if favouriteAuditories.isEmpty == false {
            Section {
                ForEach(favouriteAuditories) { auditorium in
                    NavigationLink {
                        AuditoriumDetailedView(auditorium: auditorium)
                    } label: {
                        AuditoriumView(auditorium: auditorium)
                    }
                    .contextMenu {
                        FavoriteButton(item: auditorium)
                    }

                }
            } header: {
                HeaderView("Аудитории")
                    .transition(.scale)
            }
        }

    }
    
    
    
    
//    @ViewBuilder var primaryGroupOnLoad: some View {
//        EmptyView()
//        if let primaryGroup = primaryGroup {
//            if let group = viewModel.groups.first(where: {$0.id == primaryGroup}) {
//                NavigationLink(destination: ScheduleView(viewModel: ScheduleViewModel(group)), isActive: $primaryGroupPresented) {
//                    EmptyView()
//                }
//                .hidden()
//                .onLoad {
//                    primaryGroupPresented = true
//                }
//            }
//        }
//    }
    
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
