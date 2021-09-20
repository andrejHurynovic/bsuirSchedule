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
                        Image(uiImage: photo)
                            .resizable()
                            .frame(width: 80.0, height: 80.0)
                            .clipShape(Circle())
                            .contextMenu {
                                Button {
                                    UIImageWriteToSavedPhotosAlbum(photo, nil, nil, nil)
                                } label: {
                                    Label("Сохранить фото", systemImage: "square.and.arrow.down")
                                }
                                Button {
                                    UIPasteboard.general.image = photo
                                } label: {
                                    Label("Скопировать фото", systemImage: "doc.on.doc")
                                }
                            }
                    } else {
                        Image(systemName: "person")
                            .resizable()
                            .frame(width: 80.0, height: 80.0)
                    }
                    Spacer()
                    //                    VStack(alignment: .leading) {
                    //                        Text(employee.lastName!)
                    //                            .font(.title)
                    //                            .fontWeight(.bold)
                    Text(employee.firstName! + " " + employee.middleName!)
                        .font(.title2)
                        .fontWeight(.bold)
                    //                    }
                }
            }
            
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
                    LessonsView(viewModel: LessonsViewModel(nil, employee))
                } label: {
                    Label("Расписание преподавателя", systemImage: "calendar")
                }

            }
        }.navigationTitle(employee.lastName!)
    }
}

struct EmployeeDetailedView_Previews: PreviewProvider {
    static var previews: some View {
        EmployeeDetailedView(employee: Employee(id: 228339, urlID: "iu-lutsik", firstName: "Юрий", middleName: "Александрович", lastName: "Луцик", rank: "доцент", degree: "к.т.н.", departments: ["ЭВМ", "Физики"], favorite: true, photoLink: "http://risovach.ru/upload/2014/09/mem/paca_62524324_orig_.jpeg", photo: UIImage(systemName: "newspaper.fill")))
    }
}
