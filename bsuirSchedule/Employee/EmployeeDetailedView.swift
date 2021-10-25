//
//  EmployeeDetailedView.swift
//  EmployeeDetailedView
//
//  Created by Andrej Hurynovič on 8.09.21.
//

import SwiftUI

struct EmployeeDetailedView: View {
    var employee: Employee
    
    var body: some View {
        List {
            Section {
                HStack {
                    if let photo = employee.photo {
                        Image(uiImage: UIImage(data: photo)!)
                            .resizable()
                            .frame(width: 80.0, height: 80.0)
                            .clipShape(Circle())
                            .contextMenu {
                                Button {
                                    UIImageWriteToSavedPhotosAlbum(UIImage(data: photo)!, nil, nil, nil)
                                } label: {
                                    Label("Сохранить фото", systemImage: "square.and.arrow.down")
                                }
                                Button {
                                    UIPasteboard.general.image = UIImage(data: photo)!
                                } label: {
                                    Label("Скопировать фото", systemImage: "doc.on.doc")
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
            
            if let groups = employee.groups(), groups.isEmpty == false {
                Section("Группы") {
                    ForEach(groups) { group in
                        NavigationLink {
                            LessonsView(viewModel: LessonsViewModel(group))
                        } label: {
                            Text(group.id!)
                        }
                    }
                }
            }
        }.navigationTitle(employee.lastName!)
    }
}
