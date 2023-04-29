//
//  AuditoriumsView.swift
//  AuditoriumsView
//
//  Created by Andrej Hurynovič on 25.09.21.
//

import SwiftUI

struct AuditoriumsView: View {
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\Auditorium.building),
        SortDescriptor(\Auditorium.formattedName)],
                  animation: .spring())
    var auditoriums: FetchedResults<Auditorium>
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\AuditoriumType.id)])
    var auditoriumTypes: FetchedResults<AuditoriumType>
    
    @StateObject private var viewModel = AuditoriumsViewModel()
    
    //MARK: - Body
    
    var body: some View {
        NavigationView {
            ScrollView {
                AuditoriumsGridView(sections: auditoriums.sections(viewModel.selectedSectionType))
                TotalFooterView(text: "Аудиторий", count: auditoriums.count)
            }
            .navigationTitle("Аудитории")
            .refreshable { await viewModel.update() }
            
            .toolbar { toolbar }
            
            .searchable(text: $viewModel.searchText, prompt: "Номер, подразделение")
            .onChange(of: viewModel.searchText) { _ in auditoriums.nsPredicate = viewModel.calculatePredicate() }
            .baseBackground()
        }
    }
    
    //MARK: - Toolbar
    
    @ViewBuilder var toolbar: some View {
        MenuView(defaultRules: viewModel.menuDefaultRules) {
            SectionTypePicker(value: $viewModel.selectedSectionType)
            auditoriumTypeSelector
        }
    }
    
    @ViewBuilder var auditoriumTypeSelector: some View  {
        Text("Тип:")
        Picker("", selection: $viewModel.selectedAuditoriumType) {
            Text("Любой").tag(nil as AuditoriumType?)
            ForEach(auditoriumTypes, id: \.self) { type in
                Text(type.abbreviation)
                    .tag(type.self as AuditoriumType?)
            }
        }
        .onChange(of: viewModel.selectedAuditoriumType) { _ in auditoriums.nsPredicate = viewModel.calculatePredicate() }
        
    }
    

}

struct AuditoriumsView_Previews: PreviewProvider {
    static var previews: some View {
        AuditoriumsView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
