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
    
    //MARK: Group
    
    @ViewBuilder var squareObjects: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 104, maximum: 256))], alignment: .leading, spacing: 8, pinnedViews: [.sectionHeaders]) {
            
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
        .padding()
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
            .preferredColorScheme(.dark)
    }
}

struct EmployeeFavoriteView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var employee: Employee
    
    var body: some View {
        NavigationLink {
            EmployeeDetailedView(employee: employee)
        } label: {
            HStack {
                if let photo = employee.photo {
                    Image(uiImage: UIImage(data: photo)!)
                        .resizable()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                }
                //                                Spacer()
                VStack(alignment: .leading) {
                    Text(employee.lastName ?? "")
                        .font(.title)
                        .fontWeight(.bold)
                    Text(employee.firstName! + " " + employee.middleName!)
                }
                .foregroundColor(Color.primary)
                Spacer()
                VStack() {
                    if !employee.departments!.isEmpty {
                        Text(employee.departments!.joined(separator: ", \n"))
                            .foregroundColor(Color.gray)
                            .multilineTextAlignment(.trailing)
                    }
                }
            }
            .padding()
            .clipped()
            .background(in: RoundedRectangle(cornerRadius: 16))
            .standardizedShadow()
        }
    }
}
