//
//  GroupDetailedView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 21.04.22.
//

import SwiftUI

struct GroupDetailedView: View {
    
    @ObservedObject var group: Group
    @StateObject var viewModel = GroupViewModel()
    
    var body: some View {
        Form {
            specialitySection
            groupSection
            nickname
            links
        }
        .navigationTitle(group.name)
        .toolbar {
            FavoriteButton(item: group,
                           circle: true)
        }
        .refreshable { let _ = await group.update() }
        
        .animation(.default, value: group.favorite)
        .animation(.default, value: group.lessonsUpdateDate)
        .animation(.default, value: group.lessons)
        
        .task {
            let _ = await group.checkForLessonsUpdates()
        }
        
    }
    
    @ViewBuilder var specialitySection: some View {
        if let speciality = group.speciality {
            Section(speciality.name) {
                FormView("Аббревиатура", speciality.abbreviation)
                FormViewWithAlternativeText("Факультет",
                                            speciality.faculty?.abbreviation,
                                            speciality.faculty?.name)
                FormView("Степень", group.educationDegree?.description)
                FormView("Форма обучения", speciality.educationType?.name)
                FormView("Шифр", speciality.code)
            }
        }
        
        
    }
    
    //MARK: - groupSection
    
    @ViewBuilder var groupSection: some View {
        Section("Группа") {
            FormView("Курс", String(group.course))
            numberOfStudents
            EducationBoundedView(item: group)
            LessonsRefreshableView(item: group )
        }
    }
    
    @ViewBuilder var numberOfStudents: some View {
        if group.numberOfStudents != 0 {
            FormView("Количество студентов",  String(group.numberOfStudents))
        }
    }
    
    //MARK: - Nickname
    
    @ViewBuilder var nickname: some View {
        if group.favorite {
            Section("Псевдоним") {
                TextField("Ввести псевдоним группы", text: $viewModel.nicknameString)
                    .foregroundColor(viewModel.nicknameString.isEmpty ? .secondary : .primary)
                    .onSubmit {
                        viewModel.submitNickname(group)
                    }
                    .task {
                        viewModel.nicknameString = group.nickname ?? ""
                    }
            }
        }
    }
    
    //MARK: - Links
    
    @ViewBuilder var links: some View {
        if let groupLessons = group.lessons?.allObjects as? [Lesson], groupLessons.isEmpty == false {
            Section("Ссылки") {
                lessons
                flow
                employees
            }
        }
    }
    @ViewBuilder var lessons: some View {
        ScheduleNavigationLink(scheduled: group)
    }
    @ViewBuilder var flow: some View {
        if let flow = group.flow {
            DisclosureGroup {
                ForEach(flow) { group in
                    NavigationLink(destination: GroupDetailedView(group: group)){
                        Text(group.name)
                    }
                }
            } label: {
                Label("Поток", systemImage: "bookmark")
            }
        }
    }
    @ViewBuilder var employees: some View {
        if let employees = group.employees {
            EmployeesFormView(employees: employees)
        }
    }
    
}

struct GroupDetailedView_Previews: PreviewProvider {
    static var previews: some View {
        let groups: [Group] = Group.getAll()
        
        if let group = groups.first(where: { $0.name == "950502" }) {
            NavigationView {
                GroupDetailedView(group: group)
            }
        }
    }
}
