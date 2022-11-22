//
//  FavoritesView.swift
//  FavoritesView
//
//  Created by Andrej Hurynovič on 21.09.21.
//

import SwiftUI

class FavouriteViewModel: ObservableObject {
    @AppStorage("primaryGroup") var primaryGroupID: String?
    @State var groupSection: LessonsSection?
    @AppStorage("primaryEmployee") var primaryEmployeeID: Int?
    @State var employeeSection: LessonsSection?
    @AppStorage("primaryClassroom") var primaryClassroomID: String?
    @State var classroomSection: LessonsSection?
}

struct FavoritesView: View {
    
    @ObservedObject var viewModel = FavouriteViewModel()
    
    @FetchRequest(
        entity: Group.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Group.id, ascending: true)],
        predicate:
            NSPredicate(format: "favourite = true"))
    var favouriteGroups: FetchedResults<Group>
    @FetchRequest(
        entity: Employee.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Employee.lastName, ascending: true),
            NSSortDescriptor(keyPath: \Employee.firstName, ascending: true)],
        predicate: NSPredicate(format: "favourite = true"))
    var favouriteEmployees: FetchedResults<Employee>
    @FetchRequest(
        entity: Classroom.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Classroom.originalName, ascending: true)],
        predicate:
            NSPredicate(format: "favourite = true"))
    var favouriteClassrooms: FetchedResults<Classroom>
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    primaryGroup
                    primaryEmployee
                    primaryClassroom
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
    
    @ViewBuilder var primaryGroup: some View {
        if let primaryGroupID = viewModel.primaryGroupID, let group = favouriteGroups.first(where: { $0.id == primaryGroupID }) {
            VStack(alignment: .leading) {
                FavoriteSectionView(viewModel: FavoriteSectionViewModel(lessonsSectioned: group))
            }
        }
    }
    @ViewBuilder var primaryEmployee: some View {
        if let primaryEmployeeID = viewModel.primaryEmployeeID, let employee = favouriteEmployees.first(where: { $0.id == primaryEmployeeID }) {
            FavoriteSectionView(viewModel: FavoriteSectionViewModel(lessonsSectioned: employee))
            }
        }
    
    @ViewBuilder var primaryClassroom: some View {
        if let primaryClassroomID = viewModel.primaryClassroomID, let classroom = favouriteClassrooms.first(where: { $0.originalName == primaryClassroomID }) {
            FavoriteSectionView(viewModel: FavoriteSectionViewModel(lessonsSectioned: classroom))
        }
    }
    
    //MARK: Grids
    
    @ViewBuilder var squareObjects: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 104, maximum: 500))], alignment: .leading, spacing: 8, pinnedViews: [.sectionHeaders]) {
//            tasks
            groups
            classrooms
        }
        .padding([.leading, .horizontal, .top])
    }
    
    @ViewBuilder var rectangleObjects: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 240, maximum: 500))], alignment: .leading, spacing: 8, pinnedViews: [.sectionHeaders]) {
            employees
        }
        .padding(.horizontal)
    }
    
    //MARK: Objects
    
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
//                standardizedHeader(title: "Задания")
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
                        LessonsView(viewModel: LessonsViewModel(group))
                    } label: {
                        FavoriteGroupView(group: group)
                    }
                    .contextMenu {
                        FavoriteButton(group.favourite) {
                            group.favourite.toggle()
                        }
                    }
                    
                }
            } header: {
                standardizedHeader(title: "Группы")
                    .transition(.scale)
            }
        }
        
    }
    
    @ViewBuilder var employees: some View {
        if favouriteEmployees.isEmpty == false {
            Section {
                ForEach(favouriteEmployees) { employee in
                    NavigationLink {
                        LessonsView(viewModel: LessonsViewModel(employee))
                    } label: {
                        EmployeeFavoriteView(employee: employee)
                    }
                    .contextMenu {
                        FavoriteButton(employee.favourite) {
                            employee.favourite.toggle()
                        }
                    }
                    
                }
            } header: {
                standardizedHeader(title: "Преподаватели")
                    .transition(.scale)
            }
        }
    }
    @ViewBuilder var classrooms: some View {
        if favouriteClassrooms.isEmpty == false {
            Section {
                ForEach(favouriteClassrooms) { classroom in
                    NavigationLink {
                        ClassroomDetailedView(classroom: classroom)
                    } label: {
                        ClassroomView(classroom: classroom, favorite: true)
                    }
                    .contextMenu {
                        FavoriteButton(classroom.favourite) {
                            classroom.favourite.toggle()
                        }
                    }

                }
            } header: {
                standardizedHeader(title: "Кабинеты")
                    .transition(.scale)
            }
        }

    }
    
    
    
    
//    @ViewBuilder var primaryGroupOnLoad: some View {
//        EmptyView()
//        if let primaryGroup = primaryGroup {
//            if let group = viewModel.groups.first(where: {$0.id == primaryGroup}) {
//                NavigationLink(destination: LessonsView(viewModel: LessonsViewModel(group)), isActive: $primaryGroupPresented) {
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
