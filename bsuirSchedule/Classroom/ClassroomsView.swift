//
//  ClassroomsView.swift
//  ClassroomsView
//
//  Created by Andrej Hurynovič on 25.09.21.
//

import SwiftUI

struct ClassroomsView: View {
    
    @StateObject private var viewModel = ClassroomsViewModel()
    
    @State var searchText = ""
    @State var classroomTypes: [ClassroomType: Binding<Bool>] = ClassroomsViewModel.classroomsTypesDefaults()
    @State var buildings: [Bool] = ClassroomsViewModel.buildingsDefaults()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 104, maximum: 256))], alignment: .leading, spacing: 8, pinnedViews: [.sectionHeaders]) {
                    ForEach(viewModel.sections(), id: \.self) { section in
                        let classrooms: [Classroom] = section.classrooms(searchText, classroomTypes, buildings)
                        if classrooms.isEmpty == false {
                            Section {
                                ForEach(classrooms, id: \.self) { classroom in
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
                }
                .padding()
            }
            .navigationTitle("Кабинеты")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Menu {
                        Text("Тип кабинета:")
                        ForEach(ClassroomType.allCases, id: \.rawValue) {classroomType in
                            Toggle(isOn: classroomTypes[classroomType]!) {
                                let _ = print(classroomTypes[classroomType])
                                Text(classroomType.description)
                            }
                        }
                        Text("Корпуса")
                        ForEach(1...8, id: \.self) {index in
                            Toggle(isOn: $buildings[index - 1]) {
                                Text(String(index))
                            }
                        }
                    } label: {
//                        Image(systemName: classroomTypes == ClassroomsViewModel.classroomsTypesDefaults() ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
                        Image(systemName: true == true ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
                    }
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
            .searchable(text: $searchText, prompt: "Номер, кафедра")
    }
}

struct ClassroomsView_Previews: PreviewProvider {
    static var previews: some View {
        ClassroomsView()
            .previewInterfaceOrientation(.portrait)
    }
}
