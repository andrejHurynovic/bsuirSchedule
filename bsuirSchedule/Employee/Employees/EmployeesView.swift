//
//  EmployeesView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 3.06.21.
//

import SwiftUI

struct EmployeesView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\Employee.lastName),
                                    SortDescriptor(\Employee.firstName),
                                    SortDescriptor(\Employee.middleName)],
                  animation: .spring())
    var employees: FetchedResults<Employee>
    
    @StateObject private var viewModel = EmployeesViewModel()
    
    @State var searchText = ""
    
    //MARK: - Body
    
    var body: some View {
        NavigationView {
            ScrollView {
                let sections = Array(employees).sections(.firstLetter)
                EmployeesGridView(sections: sections)
                TotalFooterView(text: "Преподавателей", count: employees.count)
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("Преподаватели")
            .refreshable { await viewModel.update() }
            
            .searchable(text: $searchText, prompt: "Фамилия, имя, подраздедение")
            .onChange(of: searchText) { newText in
                employees.nsPredicate = viewModel.calculatePredicate(searchText)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
}

struct EmployeesView_Previews: PreviewProvider {
    static var previews: some View {
        EmployeesView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
    
}
