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
    @State var selectedSectionType: EmployeeSectionType = .firstLetter
    @State var showDepartments = false
    
    //MARK: - Body
    
    var body: some View {
            ScrollView {
                EmployeesGridView(sections: employees.sections(selectedSectionType),
                                  showDepartments: showDepartments)
                TotalFooterView(text: "Преподавателей", count: employees.count)
            }
            .navigationTitle("Преподаватели")
            .refreshable { await EmployeesViewModel.update() }
            
            .toolbar { toolbar }
            
            .searchable(text: $searchText, prompt: "Фамилия, имя, подраздедение")
            .onChange(of: searchText) { newText in
                employees.nsPredicate = viewModel.calculatePredicate(searchText)
            }
            
            .baseBackground()
    }
    
    //MARK: - Toolbar
    
    @ViewBuilder var toolbar: some View {
        MenuView(defaultRules: [selectedSectionType == .firstLetter]) {
            SectionTypePicker(value: $selectedSectionType)
            showDepartmentsToggle
        }
    }
    
    var showDepartmentsToggle: some View {
        Toggle(isOn: $showDepartments.animation()) {
            Text("Отображать подразделения")
        }
    }
}

struct EmployeesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EmployeesView()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
    }
    
}
