//
//  EmployeeDetailedView.swift
//  EmployeeDetailedView
//
//  Created by Andrej Hurynovič on 8.09.21.
//

import SwiftUI

struct EmployeeDetailedView: View {
    var employee: Employee
    
    @StateObject var imagesViewModel = ImagesViewModel()
    
    @State var selectedFaculty: Faculty? = nil
    @State var selectedEducationType: Int? = nil
    @State var sortedBy: GroupSortingType = .speciality
    
    var body: some View {
        List {
            Section {
                HStack {
                    if let data = employee.photo {
                        if let photo = UIImage(data: data) {
                            Button {
                                imagesViewModel.images = [photo]
                                imagesViewModel.present(selectedImage: photo)
                            } label: {
                                Image(uiImage: photo)
                                    .resizable()
                                    .frame(width: 80.0, height: 80.0)
                                    .clipShape(Circle())
                                    .contextMenu {
                                        PhotoActionButtons(image: photo)
                                    }
                            }
                        }
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 80.0, height: 80.0)
                    }
                    Spacer()
                    Text(employee.firstName! + " " + employee.middleName!)
                        .font(.title2)
                        .fontWeight(.bold)
                }
            }
            if !employee.departments!.isEmpty || !employee.degree!.isEmpty || employee.rank != nil {
                Section("Информация") {
                    if !employee.departments!.isEmpty {
                        Text("Кафедры: " + (employee.departments?.joined(separator: ", "))!)
                    }
                    
                    if !employee.degree!.isEmpty {
                        Text("Научаная степень: " + employee.degree!)
                    }
                    if let rank = employee.rank {
                        Text("Звание: " + rank)
                    }
                    
                }
            }
            
            Section("Ссылки") {
                Link(destination: URL(string: "https://iis.bsuir.by/departments/employees/" + employee.urlID!)!) {
                    Label("Контакты", systemImage: "teletype")
                }
                Link(destination: URL(string: "https://iis.bsuir.by/scheduleEmployee/" + employee.urlID!)!) {
                    Label("Расписание в ИИС", systemImage: "calendar")
                }
            }
            
            if let _ = employee.lessons?.allObjects as? [Lesson] {
                NavigationLink {
                    LessonsView(viewModel: LessonsViewModel(employee))
                } label: {
                    Label("Расписание преподавателя", systemImage: "calendar")
                }

            }
            
            if let groups = LessonStorage.groups(lessons: employee.lessons), groups.isEmpty == false {
                Section("Группы") {}
                    GroupList(groups: groups, searchText: nil, selectedFaculty: $selectedFaculty, selectedEducationType:
                                $selectedEducationType, sortedBy: $sortedBy)
            }
        }
        .overlay {
            ImagesView()
                .environmentObject(imagesViewModel)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    FavoriteButton(employee.favorite, circle: true) {
                        employee.favorite.toggle()
                    }
                    GroupToolbarMenu(selectedFaculty: $selectedFaculty, selectedEducationType: $selectedEducationType, sortedBy: $sortedBy)
                } label: {
                    Image(systemName: (selectedFaculty == nil && selectedEducationType == nil) ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
                }
            }
        }
        .navigationTitle(employee.lastName!)
    }
}
