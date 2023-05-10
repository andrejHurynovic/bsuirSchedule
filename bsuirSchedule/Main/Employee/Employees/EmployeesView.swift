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
    private var employees: FetchedResults<Employee>
    
    @StateObject private var viewModel = EmployeesViewModel()
    
    //MARK: - Body
    
    var body: some View {
        ScrollViewReader { scrollViewProxy in
            ZStack {
                ScrollView {
                    VStack {
                        EmployeesGridView(sections: employees.sections(viewModel.selectedSectionType),
                                          showDepartments: viewModel.showDepartments)
                        .padding(.trailing, viewModel.showSectionIndexes ? 8 : 0)
                        .id(UUID())
                        TotalFooterView(text: "Преподавателей", count: employees.count)
                    }
                }
                sectionIndexes
            }
            .navigationTitle("Преподаватели")
            .refreshable { await EmployeesViewModel.update() }
            
            .toolbar { toolbar }
            
            .searchable(text: $viewModel.searchText, prompt: "Фамилия, имя, подраздедение")
            .onChange(of: viewModel.predicate) { predicate in
                employees.nsPredicate = predicate
            }
            .onChange(of: viewModel.scrollTargetID, perform: { id in
                guard let id = id else { return }
                withAnimation {
                    scrollViewProxy.scrollTo(id, anchor: .top)
                }
            })
                        
            .baseBackground()
        }
    }
    
    @ViewBuilder var sectionIndexes: some View {
        if viewModel.showSectionIndexes {
            HStack {
                Spacer()
                VStack(alignment: .center) {
                    ForEach(Constants.alphabet, id: \.self) { letter in
                        Button(action: {
                            viewModel.scrollTargetID = letter
                        }, label: {
                            Text(letter)
                                .font(.system(size: 12))
                                .padding(.trailing, 8)
                        })
                    }
                }
            }
        }
    }
    
    //MARK: - Toolbar
    
    @ViewBuilder var toolbar: some View {
        MenuView(defaultRules: viewModel.menuDefaultRules) {
            SectionTypePicker(value: $viewModel.selectedSectionType)
            showDepartmentsToggle
        }
    }
    
    var showDepartmentsToggle: some View {
        Toggle(isOn: $viewModel.showDepartments.animation()) {
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
