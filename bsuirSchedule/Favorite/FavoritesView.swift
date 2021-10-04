//
//  FavoritesView.swift
//  FavoritesView
//
//  Created by Andrej Hurynovič on 21.09.21.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject var viewModel = FavoritesViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                if viewModel.groups.isEmpty == false {
                    VStack(alignment: .leading) {
                        Text("Группы")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.leading)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 96, maximum: 256), spacing: nil, alignment: nil)],
                              alignment: .center, spacing: nil,
                              pinnedViews: []) {
                        
                        ForEach(viewModel.groups, id: \.self) {group in
                            ZStack {
                                FavoriteGroupView(group: group)
                                    .contextMenu {
                                        Button {
                                            withAnimation(.spring()) {
                                                viewModel.removeFromFavorites(group)
                                            }
                                        } label: {
                                            Label("Убрать из избранных", systemImage: "star.circle")
                                        }
                                    }
                            }
                        }
                    }
                              .padding([.leading, .bottom, .trailing])
                }
                
                if viewModel.employees.isEmpty == false {
                    VStack(alignment: .leading) {
                        Text("Преподаватели")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.leading)
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    
                    LazyVStack {
                        ForEach(viewModel.employees) { employee in
                            Section {
                                EmployeeFavoriteView(employee: employee)
                            }
                            .contextMenu {
                                Button {
                                    withAnimation(.spring()) {
                                        viewModel.removeFromFavorites(nil, employee)
                                    }
                                } label: {
                                    Label("Убрать из избранных", systemImage: "star.circle")
                                }
                                NavigationLink(destination: LessonsView(viewModel: LessonsViewModel(nil, employee))) {
                                    Label("Расписание", systemImage: "calendar")
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Избранные")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}



struct FavoriteGroupView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var group: Group
    
    var body: some View {
        NavigationLink {
            LessonsView(viewModel: LessonsViewModel(group, nil))
        } label: {
            VStack(alignment: .leading) {
                Text(group.id!)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(Color.primary)
                Spacer()
                Text(group.faculty!.abbreviation!)
                    .foregroundColor(Color.primary)
                Text(String(group.course) + "-й курс")
                    .font(.headline)
                    .fontWeight(.regular)
                    .foregroundColor(Color.gray)
                
            }
        }
        .padding()
        .frame(width: 112, height: 112)
        .clipped()
        .background(in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: colorScheme == .dark ? Color(#colorLiteral(red: 255, green: 255, blue: 255, alpha: 0.2)) : Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1)), radius: 5, x: 0, y: 0)
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
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
                    Text(employee.lastName!)
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
            .shadow(color: colorScheme == .dark ? Color(#colorLiteral(red: 255, green: 255, blue: 255, alpha: 0.2)) : Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1)), radius: 5, x: 0, y: 0)
        }
    }
}
