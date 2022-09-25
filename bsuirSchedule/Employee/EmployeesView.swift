//
//  EmployeesView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 3.06.21.
//

import SwiftUI

struct EmployeesView: View {
    @StateObject private var viewModel = EmployeesViewModel()
    @State var searchText = ""
    
    
    var body: some View {
        NavigationView {
            ZStack {
                if let employees = viewModel.foundEmployees(searchText), employees.isEmpty == false {
                    List {
                        ForEach(employees, id: \.id) { employee in
                            EmployeeView(employee: employee)
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button {
                                        employee.favourite.toggle()
                                    } label: {
                                        Image(systemName: employee.favourite ? "star.slash" : "star")
                                    }
                                    
                                }.background(NavigationLink("", destination: {
                                    EmployeeDetailedView(viewModel: EmployeeViewModel(employee))
                                }).opacity(0))
                        }
                        HStack {
                            Text("Всего преподавателей: \(employees.count)")
                        }
                    }
                    .refreshable {
                        viewModel.fetchEmployees()
                    }
                } else {
                    Text("Ничего не найдено")
                        .foregroundColor(Color.gray)
                }
                
                if viewModel.employees.isEmpty {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .onAppear {
                            viewModel.fetchEmployees()
                        }
                }
            }
            .navigationTitle("Преподаватели")
            .searchable(text: $searchText, prompt: "Фамилия, кафедра")
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct EmployeesView_Previews: PreviewProvider {
    static var previews: some View {
        EmployeesView()
    }
}
