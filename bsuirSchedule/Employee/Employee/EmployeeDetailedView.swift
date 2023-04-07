//
//  EmployeeDetailedView.swift
//  EmployeeDetailedView
//
//  Created by Andrej Hurynovič on 8.09.21.
//

import SwiftUI

struct EmployeeDetailedView: View {
    
    @ObservedObject var employee: Employee
    @StateObject var viewModel: EmployeeViewModel = EmployeeViewModel()
    
    var body: some View {
        Form {
            title
            information
            links
            groups
        }
        .animation(.default, value: employee.lessonsUpdateDate)

        .refreshable {
            let _ = await employee.update()
        }
        
        .navigationTitle(employee.lastName)
        
        .toolbar { FavoriteButton(item: employee, circle: true) }
        
        .task {
            if employee.lessonsUpdateDate == nil {
                let _ = await employee.update()
            }
        }
    }
    
    //MARK: - Title
    
    var title: some View {
        EmployeeView(employee: employee,
                     showTitle: false,
                     showDepartments: false)
        .contextMenu {
            if let data = employee.photo,
               let uiImage = UIImage(data: data) {
                let photo = Image(uiImage: uiImage)
                ShareLink(item: photo,
                          preview: SharePreview("Поделиться фото",
                                                image: photo))
            }
        } preview: {
            if let photo = employee.photo {
                Image(uiImage: UIImage(data: photo)!)
            }
        }
        
    }
    
    //MARK: - Information
    
    @ViewBuilder var information: some View {
        Section("Информация") {
            if let degreeAbbreviation = employee.degreeAbbreviation {
                FormViewWithAlternativeText("Научная степень",
                                            degreeAbbreviation,
                                            employee.degree)
            }
            if let rank = employee.rank {
                FormView("Звание", rank)
            }
            EducationDatesView(item: employee)
            lastUpdate
        }
    }
    
    //MARK: - Links
    
    var links: some View {
        Section("Ссылки") {
            lessons
            departments
            urlLinks
        }
    }
    
    @ViewBuilder var departments: some View {
        if let departments = employee.departments?.allObjects as? [Department] {
            //One department.
            if departments.count == 1, let department = departments.first {
                NavigationLink {
                    //                            DepartmentDetailedView(department: department)
                } label: {
                    Label(department.formattedName,
                          systemImage: "person.2.fill")
                }
            } else {
                //Multiple departments.
                DisclosureGroup {
                    ForEach(departments, id: \.self) { department in
                        NavigationLink {
                            //                            DepartmentDetailedView(department: department)
                        } label: {
                            Text(department.formattedName)
                        }
                    }
                } label: {
                    Label("Подразделения",
                          systemImage: "person.2.fill")
                }
            }
        }
    }
    @ViewBuilder var urlLinks: some View {
        Link(destination: URL(string: "https://iis.bsuir.by/departments/employees/" + employee.urlID!)!) {
            Label("Контакты", systemImage: "teletype")
        }
        Link(destination: URL(string: "https://iis.bsuir.by/scheduleEmployee/" + employee.urlID!)!) {
            Label("Расписание в ИИС", systemImage: "globe")
        }
    }
    @ViewBuilder var lessons: some View {
        if let lessons = employee.lessons?.allObjects as? [Lesson], lessons.isEmpty == false {
            NavigationLink {
                LessonsView(viewModel: LessonsViewModel(employee))
            } label: {
                Label("Расписание преподавателя", systemImage: "calendar")
            }
        }
    }
    
    //MARK: - Last update
    
    @ViewBuilder var lastUpdate: some View {
        HStack {
            Text("Последнее обновление")
            Spacer()
            if let date = viewModel.lastUpdateDate {
                Text(date.formatted(date: .numeric, time: .omitted))
                    .foregroundColor(.secondary)
            } else {
                ProgressView()
                    .task {
                        if viewModel.lastUpdateDate == nil {
                            await viewModel.fetchLastUpdateDate(employee: employee)
                        }
                    }
                    .progressViewStyle(CircularProgressViewStyle(tint: .gray))
            }
        }
    }
    
    //MARK: - Groups
    
    @ViewBuilder var groups: some View {
        let groups = employee.groups
        if groups.isEmpty == false {
            GroupsSectionsView(sections: groups.sections(), groupsCount: groups.count)
        }
    }
}

struct EmployeeDetailedView_Previews: PreviewProvider {
    static var previews: some View {
        let employees = Employee.getAll()
        if let employee = employees.first(where: {
            $0.departmentsArray != nil &&
            $0.degreeAbbreviation != nil &&
            $0.rank != nil &&
            $0.lessons != nil
        }) {
            NavigationView {
                EmployeeDetailedView(employee: employee)
            }
        }
        
    }
}
