//
//  EmployeesView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 3.06.21.
//

import SwiftUI

struct EmployeesView: View {
    @FetchRequest(entity: Employee.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Employee.lastName, ascending: true),
                                                               NSSortDescriptor(keyPath: \Employee.firstName, ascending: true)]) var employees: FetchedResults<Employee>
    
    @StateObject private var viewModel = EmployeesViewModel()
    @State var searchText = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                let employees = employees.filter {
                    $0.lastName!.localizedStandardContains(searchText) == true ||
                    $0.departments!.contains(where: { $0.localizedStandardContains(searchText) }) == true
                }
                
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
                    await viewModel.update()
                }
                .navigationTitle("Преподаватели")
                .searchable(text: $searchText, prompt: "Фамилия, кафедра")
            }.navigationViewStyle(StackNavigationViewStyle())
        }
    }
    
}

struct EmployeesView_Previews: PreviewProvider {
    static var previews: some View {
        EmployeesView()
    }
    
}
