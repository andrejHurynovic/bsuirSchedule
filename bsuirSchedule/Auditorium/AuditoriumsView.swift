//
//  AuditoriumsView.swift
//  AuditoriumsView
//
//  Created by Andrej Hurynovič on 25.09.21.
//

import SwiftUI

struct AuditoriumsView: View {
    @FetchRequest(entity: Auditorium.entity(), sortDescriptors: []) var auditoriums: FetchedResults<Auditorium>
    
    @StateObject private var viewModel = AuditoriumsViewModel()
    
    @State var searchText = ""
    @State var selectedAuditoriumType: AuditoriumType? = nil
    @State var selectedBuilding: Int16? = nil
    
    var body: some View {
        NavigationView {
            let filteredAuditoriums = auditoriums
                .filter { searchText.isEmpty || $0.formattedName(showBuilding: true).localizedStandardContains(searchText) }
                .filtered(by: selectedBuilding, selectedAuditoriumType)
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 104, maximum: 256))], alignment: .leading, spacing: 8, pinnedViews: [.sectionHeaders]) {
                    ForEach(filteredAuditoriums.sections(), id: \.self) { section in
                        Section {
                            ForEach(section.auditoriums, id: \.self) { auditorium in
                                NavigationLink {
                                    AuditoriumDetailedView(auditorium: auditorium)
                                } label: {
                                    AuditoriumView(auditorium: auditorium)
                                }
                                .contextMenu {
                                    FavoriteButton(auditorium.favourite) {
                                        auditorium.favourite.toggle()
                                    }
                                }
                            }
                        } header: {
                            standardizedHeader(title: section.title)
                        }
                        
                    }
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Text("Тип:")
                        let types = Set(auditoriums.compactMap ({ $0.type })).sorted { $0.id < $1.id }
                        Picker("", selection: $selectedAuditoriumType) {
                            Text("любой").tag(nil as AuditoriumType?)
                            ForEach(types, id: \.self) { type in
                                Text(type.abbreviation)
                                    .tag(type.self as AuditoriumType?)
                            }
                        }
                        Text("Здание:")
                        let buildings = Set(auditoriums.map ({ $0.building })).sorted { $0 < $1 }
                        Picker("", selection: $selectedBuilding) {
                            Text("любое").tag(nil as Int16?)
                            ForEach(buildings, id: \.self) { building in
                                Text(String(building))
                                    .tag(building as Int16?)
                            }
                        }
                    } label: {
                        Image(systemName: (selectedAuditoriumType == nil && selectedBuilding == nil) ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
                    }
                }
            }
            .navigationTitle("Аудитории")
            .refreshable {
                await viewModel.update()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .searchable(text: $searchText, prompt: "Номер, подразделение")
    }
}

struct AuditoriumsView_Previews: PreviewProvider {
    static var previews: some View {
        AuditoriumsView()
            .previewInterfaceOrientation(.portrait)
    }
}
