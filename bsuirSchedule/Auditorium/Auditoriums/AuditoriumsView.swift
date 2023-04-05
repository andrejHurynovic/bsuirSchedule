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
    
    @State var searchText = ""
    @State var selectedSectionType: AuditoriumSectionType = .building
    @State var selectedAuditoriumType: AuditoriumType? = nil
    
    var defaultRules: [Bool] { [selectedSectionType == .building,
                                selectedAuditoriumType == nil] }
    
    //MARK: - Body
    
    var body: some View {
        NavigationView {
            ScrollView {
                let sections = Array(auditoriums).sections(selectedSectionType)
                AuditoriumsGridView(sections: sections)
                TotalFooterView(text: "Аудиторий", count: auditoriums.count)
            }
            .navigationTitle("Аудитории")
            .refreshable { await viewModel.update() }
            
            .toolbar { toolbar }
            
            .searchable(text: $searchText, prompt: "Номер, подразделение")
            .onChange(of: searchText) { newText in
                auditoriums.nsPredicate = viewModel.calculatePredicate(selectedAuditoriumType, newText)
            }
            .background(Color(UIColor.systemGroupedBackground))
        }
    }
    
    //MARK: - Toolbar
    
    @ViewBuilder var toolbar: some View {
        MenuView(defaultRules: defaultRules) {
            SortingPicker(value: $selectedSectionType)
            auditoriumTypeSelector
        }
    }
    
    @ViewBuilder var auditoriumTypeSelector: some View  {
        Text("Тип:")
        Picker("", selection: $selectedAuditoriumType) {
            Text("Любой").tag(nil as AuditoriumType?)
            ForEach(auditoriumTypes, id: \.self) { type in
                Text(type.abbreviation)
                    .tag(type.self as AuditoriumType?)
            }
        }
        .onChange(of: selectedAuditoriumType) { newType in
            auditoriums.nsPredicate = viewModel.calculatePredicate(newType, searchText)
        }
        
    }
    

}

struct AuditoriumsView_Previews: PreviewProvider {
    static var previews: some View {
        AuditoriumsView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
