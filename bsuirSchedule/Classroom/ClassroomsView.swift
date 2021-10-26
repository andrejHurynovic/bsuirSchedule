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
    @State var classroomTypes: [Bool] = ClassroomsViewModel.classroomsTypesDefaults()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 104, maximum: 256))], alignment: .center, spacing: 8, pinnedViews: [.sectionHeaders]) {
                    ForEach(viewModel.sections(), id: \.self) { section in
                        let classrooms: [Classroom] = section.classrooms(searchText, classroomTypes)
                        if classrooms.isEmpty == false {
                            Section {
                                ForEach(classrooms, id: \.self) { classroom in
                                    NavigationLink {
                                        ClassroomDetailedView(classroom: classroom)
                                    } label: {
                                        ClassroomView(classroom: classroom)
                                    }
                                }
                            } header: {
                                Text(section.title)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .padding(.horizontal)
                                    .padding(.vertical, 4)
                                    .background(ColorManager.shared.mainColor)
                                    .clipShape(Capsule())
                                    .padding(.vertical, 4)
                                    .shadow(color: ColorManager.shared.mainColor, radius: 8)
                                    .foregroundColor(.white)
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
                        ForEach(1...7, id: \.self) {index in
                            Toggle(isOn: $classroomTypes[index - 1]) {
                                Text(Classroom.classroomTypeDescription(index))
                            }
                        }
                    } label: {
                        Image(systemName: classroomTypes == ClassroomsViewModel.classroomsTypesDefaults() ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
                    }
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
            .searchable(text: $searchText, prompt: "Номер, кафедра")
    }
}

struct ClassroomView: View {
    
    var classroom: Classroom
    
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(.background)
            .aspectRatio(contentMode: .fill)
            .shadow(color: .secondary, radius: 6, x: 0, y: 0)
            .overlay {
                HStack {
                    VStack(alignment: .leading) {
                        Text(classroom.formattedName(showBuilding: false))
                            .font(Font.system(size: 20, weight: .bold))
                            .multilineTextAlignment(.leading)
                            .minimumScaleFactor(0.01)
                            .foregroundColor(Color.primary)
                        Spacer()
                        Text(classroom.classroomTypeDescription())
                            .foregroundColor(Color.primary)
                        if let department = classroom.departmentAbbreviation {
                            Text(department)
                                .font(.headline)
                                .fontWeight(.regular)
                                .foregroundColor(Color.gray)
                        }
                    }
                    Spacer()
                }
                .padding()
            }
        
    }
}

struct ClassroomsView_Previews: PreviewProvider {
    static var previews: some View {
        ClassroomsView()
            .previewInterfaceOrientation(.portrait)
    }
}
