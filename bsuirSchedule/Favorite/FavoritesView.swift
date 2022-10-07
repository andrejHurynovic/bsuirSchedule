//
//  FavoritesView.swift
//  FavoritesView
//
//  Created by Andrej Hurynovič on 21.09.21.
//

import SwiftUI

struct FavoritesView: View {
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
    
    
//    @StateObject var viewModel = FavoritesViewModel()
    
//    @AppStorage("primaryGroup") var primaryGroup: String?
    
//    @State var primaryGroupPresented = false
    
    var body: some View {
        NavigationView {
            ScrollView {
//                primaryGroupOnLoad
                squareObjects
                rectangleObjects
            }
            .navigationTitle("Избранные")
        }
        .navigationViewStyle(.automatic)
    }
    
    //MARK: Grids
    
    @ViewBuilder var squareObjects: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 104, maximum: 500))], alignment: .leading, spacing: 8, pinnedViews: [.sectionHeaders]) {
//            tasks
            groups
//            classrooms
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
                        //                        LessonsView(viewModel: LessonsViewModel(employee))
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
//    @ViewBuilder var classrooms: some View {
//        if classrooms.isEmpty == false {
//            Section {
//                ForEach(viewModel.classrooms) { classroom in
//                    NavigationLink {
//                        ClassroomDetailedView(classroom: classroom)
//                    } label: {
//                        ClassroomView(classroom: classroom, favorite: true)
//                    }
//                    .contextMenu {
//                        FavoriteButton(classroom.favourite) {
//                            classroom.favourite.toggle()
//                        }
//                    }
//
//                }
//            } header: {
//                standardizedHeader(title: "Кабинеты")
//                    .transition(.scale)
//            }
//        }
//
//    }
    
    
    
    
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
            .preferredColorScheme(.dark)
    }
}
