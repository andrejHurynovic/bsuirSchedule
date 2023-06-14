//
//  DepartmentsView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 5.05.23.
//

import SwiftUI

struct DepartmentsView: View {
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\Department.abbreviation)],
                  animation: .spring())
    private var departments: FetchedResults<Department>
        
    @StateObject private var viewModel = DepartmentsViewModel()
    
    var body: some View {
        ScrollView {
            DepartmentsGridView(departments: Array(departments))
            TotalFooterView(text: "Подразделений", count: departments.count)
        }
        .navigationTitle("Подразделения")
        .refreshable { await DepartmentsViewModel.update() }
                
        .searchable(text: $viewModel.searchText, prompt: "Название, аббревиатура")
        
        .overlay(content: {
            if departments.isEmpty, viewModel.searchText.isEmpty == false {
                SearchContentUnavailableView(searchText: viewModel.searchText)
            }
        })
        
        .onChange(of: viewModel.predicate) { predicate in
            departments.nsPredicate = predicate
        }
        
        .baseBackground()
        
    }
}

struct DepartmentsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DepartmentsView()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)

        }
    }
}
