//
//  AuditoriesView.swift
//  AuditoriesView
//
//  Created by Andrej Hurynovič on 25.09.21.
//

import SwiftUI

struct AuditoriesView: View {
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\Auditorium.building),
        SortDescriptor(\Auditorium.formattedName)],
                  animation: .spring())
    var auditories: FetchedResults<Auditorium>
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\AuditoriumType.id)])
    var auditoriumTypes: FetchedResults<AuditoriumType>
    
    @StateObject private var viewModel = AuditoriesViewModel()
    
    //MARK: - Body
    
    var body: some View {
        NavigationView {
            ScrollView {
                AuditoriesGridView(sections: auditories.sections(viewModel.selectedSectionType))
                TotalFooterView(text: "Аудиторий", count: auditories.count)
            }
            .navigationTitle("Аудитории")
            .refreshable { await viewModel.update() }
            
            .toolbar { toolbar }
            
            .searchable(text: $viewModel.searchText, prompt: "Номер, подразделение")
            .onChange(of: viewModel.searchText) { _ in auditories.nsPredicate = viewModel.calculatePredicate() }
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
        .onChange(of: viewModel.selectedAuditoriumType) { _ in auditories.nsPredicate = viewModel.calculatePredicate() }
        
    }
    

}

struct AuditoriesView_Previews: PreviewProvider {
    static var previews: some View {
        AuditoriesView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
