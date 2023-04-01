//
//  ClassroomsView.swift
//  ClassroomsView
//
//  Created by Andrej Hurynovič on 25.09.21.
//

import SwiftUI

struct ClassroomsView: View {
    @FetchRequest(entity: Classroom.entity(), sortDescriptors: []) var classrooms: FetchedResults<Classroom>
    
    @StateObject private var viewModel = ClassroomsViewModel()
    
    @State var searchText = ""
    @State var selectedClassroomType: ClassroomType? = nil
    @State var selectedBuilding: Int16? = nil
    
    var body: some View {
        NavigationView {
            let filteredClassrooms = classrooms
                .filter { searchText.isEmpty || $0.originalName.localizedStandardContains(searchText) }
                .filtered(by: selectedBuilding, selectedClassroomType)
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 104, maximum: 256))], alignment: .leading, spacing: 8, pinnedViews: [.sectionHeaders]) {
                    ForEach(filteredClassrooms.sections(), id: \.self) { section in
                        Section {
                            ForEach(section.classrooms, id: \.self) { classroom in
                                NavigationLink {
                                    ClassroomDetailedView(classroom: classroom)
                                } label: {
                                    ClassroomView(classroom: classroom)
                                }
                                .contextMenu {
                                    FavoriteButton(classroom.favourite) {
                                        classroom.favourite.toggle()
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
                        let types = Set(classrooms.map ({ $0.type })).sorted { $0.rawValue < $1.rawValue }
                        Picker("", selection: $selectedClassroomType) {
                            Text("любой").tag(nil as ClassroomType?)
                            ForEach(types, id: \.self) { type in
                                Text(type.abbreviation)
                                    .tag(type.self as ClassroomType?)
                            }
                        }
                        Text("Здание:")
                        let buildings = Set(classrooms.map ({ $0.building })).sorted { $0 < $1 }
                        Picker("", selection: $selectedBuilding) {
                            Text("любое").tag(nil as Int16?)
                            ForEach(buildings, id: \.self) { building in
                                Text(String(building))
                                    .tag(building as Int16?)
                            }
                        }
                    } label: {
                        Image(systemName: (selectedClassroomType == nil && selectedBuilding == nil) ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
                    }
                }
            }
            .navigationTitle("Кабинеты")
            .refreshable {
                await viewModel.update()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .searchable(text: $searchText, prompt: "Номер, кафедра")
    }
}

struct ClassroomsView_Previews: PreviewProvider {
    static var previews: some View {
        ClassroomsView()
            .previewInterfaceOrientation(.portrait)
    }
}
