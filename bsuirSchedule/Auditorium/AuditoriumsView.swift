//
//  AuditoriumsView.swift
//  AuditoriumsView
//
//  Created by Andrej Hurynovič on 25.09.21.
//

import SwiftUI

struct AuditoriumsView: View {
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.floor),
        SortDescriptor(\.name)],
                  animation: .spring())
    var auditoriums: FetchedResults<Auditorium>
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.id)])
    var auditoriumTypes: FetchedResults<AuditoriumType>
    
    @StateObject private var viewModel = AuditoriumsViewModel()
    
    @State var searchText = ""
    @State var selectedSectionType: AuditoriumSectionType = .building
    @State var selectedAuditoriumType: AuditoriumType? = nil
    
    var body: some View {
        NavigationView {
            ScrollView {
                let sections = Array(auditoriums).sections(selectedSectionType)
                AuditoriumsGridView(sections: sections)
                    .padding()
                
            }
            .navigationTitle("Аудитории")
            .toolbar { toolbar }
            .refreshable { await viewModel.update()}
            
            .searchable(text: $searchText, prompt: "Номер, подразделение")
            .onChange(of: searchText) { newText in
                auditoriums.nsPredicate = viewModel.calculatePredicate(selectedAuditoriumType, newText)
            }
            
        }
    }
    
    // MARK: - Toolbar
    
    @ViewBuilder var toolbar: some View {
        Menu {
            sectionTypeSelector
            auditoriumTypeSelector
        } label: {
            Image(systemName: (selectedAuditoriumType == nil) ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
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
    
    @ViewBuilder var sectionTypeSelector: some View  {
        Text("Сортировка:")
        Picker("", selection: $selectedSectionType.animation(.spring())) {
            ForEach(AuditoriumSectionType.allCases, id: \.self) { type in
                Text(type.description)
            }
        }
    }
}

private struct AuditoriumsGridView: View {
    let sections: [AuditoriumSection]
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 104, maximum: 256))], alignment: .leading, spacing: 8, pinnedViews: []) {
            ForEach(sections, id: \.title) { section in
                Section {
                    ForEach(section.auditoriums) { auditorium in
                        NavigationLink {
                            AuditoriumDetailedView(auditorium: auditorium)
                        } label: {
                            AuditoriumView(auditorium: auditorium)
                        }
                    }
                } header: {
                    standardizedHeader(title: section.title)
                }
                
            }
        }
    }
}

struct AuditoriumsView_Previews: PreviewProvider {
    static var previews: some View {
        AuditoriumsView()
    }
}
