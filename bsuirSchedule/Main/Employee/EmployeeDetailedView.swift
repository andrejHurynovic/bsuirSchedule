//
//  EmployeeDetailedView.swift
//  EmployeeDetailedView
//
//  Created by Andrej Hurynovič on 8.09.21.
//

import SwiftUI

struct EmployeeDetailedView: View {
    
    @ObservedObject var employee: Employee
    
    var body: some View {
        Form {
            title
            information
            links
            groups
        }
        .navigationTitle(employee.lastName)
        .toolbar { FavoriteButton(item: employee, circle: true) }
        .refreshable { let _ = await employee.update() }
        
        .animation(.default, value: employee.lessonsUpdateDate)
        
        .task {
            let _ = await employee.checkForLessonsUpdates()
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
                          preview: SharePreview("Поделиться изображением",
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
            if let degree = employee.degree {
                FormViewWithAlternativeText("Научная степень",
                                            degree.abbreviation,
                                            degree.name)
            }
            if let rank = employee.rank {
                FormView("Звание", rank)
            }
            EducationBoundedView(item: employee)
            LessonsRefreshableView(item: employee)
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
                    DepartmentDetailedView(department: department)
                } label: {
                    Label(department.formattedName,
                          systemImage: Constants.Symbols.department)
                }
            } else {
                //Multiple departments.
                DisclosureGroup {
                    ForEach(departments, id: \.self) { department in
                        NavigationLink {
                            DepartmentDetailedView(department: department)
                        } label: {
                            Text(department.formattedName)
                        }
                    }
                } label: {
                    Label("Подразделения",
                          systemImage: Constants.Symbols.department)
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
            ScheduleNavigationLink(scheduled: employee)
        }
    }
    
    //MARK: - Groups
    
    @ViewBuilder var groups: some View {
        if let groups = employee.groups {
            FormGroupsView(groups: groups)
        }
    }
}

struct EmployeeDetailedView_Previews: PreviewProvider {
    static var previews: some View {
        let employees: [Employee] = Employee.getAll()
        if let employee = employees.first(where: {
            $0.departmentsArray != nil &&
            $0.degree != nil &&
            $0.rank != nil &&
            $0.lessons != nil
        }) {
            NavigationView {
                EmployeeDetailedView(employee: employee)
            }
        }
        
    }
}
