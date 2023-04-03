//
//  EmployeesView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 3.06.21.
//

import SwiftUI

struct EmployeesView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.lastName),
                                    SortDescriptor(\.firstName)],
                  predicate: nil,
                  animation: .spring())
    var employees: FetchedResults<Employee>
    
    @StateObject private var viewModel = EmployeesViewModel()
    
    @State var searchText = ""
    
    var body: some View {
        NavigationView {
            
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
                Text("Всего преподавателей: \(employees.count)")
                
            }
            .navigationTitle("Преподаватели")
            .refreshable { await viewModel.update() }
                        
            .searchable(text: $searchText, prompt: "Фамилия, имя, подраздедение")
            .onChange(of: searchText) { newText in
                employees.nsPredicate = viewModel.calculatePredicate(searchText)
            }
        }
    }
    
}

struct EmployeesView_Previews: PreviewProvider {
    static var previews: some View {
        EmployeesView()
    }
    
}
