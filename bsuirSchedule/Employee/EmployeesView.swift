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
                List(viewModel.foundEmployees(searchText), id: \.id) { employee in
                    EmployeeView(employee: employee)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button {
                                employee.favorite.toggle()
                            } label: {
                                Image(systemName: employee.favorite ? "star.slash" : "star")
                            }
                            
                        }.background(NavigationLink("", destination: {
                            EmployeeDetailedView(employee: employee)
                        }).opacity(0))
                }
                .refreshable {
                    viewModel.fetchEmployees()
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
