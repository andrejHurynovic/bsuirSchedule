//
//  FavoritesView.swift
//  FavoritesView
//
//  Created by Andrej Hurynovič on 21.09.21.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject var viewModel = FavoritesViewModel()
    
    @AppStorage("primaryGroup") var primaryGroup: String?
    
    @State var primaryGroupPresented = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                primaryGroupOnLoad
                squareObjects
                rectangleObjects
            }
            .navigationTitle("Избранные")
        }
    }
    
    @ViewBuilder var primaryGroupOnLoad: some View {
        if let primaryGroup = primaryGroup {
            if let group = viewModel.groups.first(where: {$0.id == primaryGroup}) {
                NavigationLink(destination: LessonsView(viewModel: LessonsViewModel(group)), isActive: $primaryGroupPresented) {
                    EmptyView()
                }
                .hidden()
                .onLoad {
                    primaryGroupPresented = true
                }
            }
        }
    }
    
    @ViewBuilder var squareObjects: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 104, maximum: 500))], alignment: .leading, spacing: 8, pinnedViews: [.sectionHeaders]) {
            
            if viewModel.groups.isEmpty == false {
                Section {
                    ForEach(viewModel.groups) { group in
                        NavigationLink {
                            LessonsView(viewModel: LessonsViewModel(group))
                        } label: {
                            FavoriteGroupView(group: group)
                        }
                        .contextMenu {
                            FavoriteButton(group.favorite) {
                                group.favorite.toggle()
                            }
                        }

                    }
                } header: {
                    standardizedHeader(title: "Группы")
                        .transition(.scale)
                }
            }
            
            if viewModel.classrooms.isEmpty == false {
                Section {
                ForEach(viewModel.classrooms) { classroom in
                    NavigationLink {
                        ClassroomDetailedView(classroom: classroom)
                    } label: {
                        ClassroomView(classroom: classroom, favorite: true)
                    }
                    .contextMenu {
                        FavoriteButton(classroom.favorite) {
                            classroom.favorite.toggle()
                        }
                    }

                }
                } header: {
                    standardizedHeader(title: "Кабинеты")
                        .transition(.scale)
                }
            }
            
        }
        .padding([.leading, .horizontal, .top])
    }
    
    @ViewBuilder var rectangleObjects: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 240, maximum: 500))], alignment: .leading, spacing: 8, pinnedViews: [.sectionHeaders]) {
            
            if viewModel.employees.isEmpty == false {
                Section {
                    ForEach(viewModel.employees) { employee in
                        NavigationLink {
                            LessonsView(viewModel: LessonsViewModel(employee))
                        } label: {
                            EmployeeFavoriteView(employee: employee)
                        }
                        .contextMenu {
                            FavoriteButton(employee.favorite) {
                                employee.favorite.toggle()
                            }
                        }

                    }
                } header: {
                    standardizedHeader(title: "Преподаватели")
                        .transition(.scale)
                }
            }
            
        }
        .padding([.leading, .horizontal])
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
            .preferredColorScheme(.dark)
    }
}


