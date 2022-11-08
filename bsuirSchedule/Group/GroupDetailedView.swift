//
//  GroupDetaildView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 21.04.22.
//

import SwiftUI
import Combine

struct GroupDetailedView: View {
    
    @ObservedObject var viewModel: GroupViewModel
    
    var body: some View {
        List {
            information
            Section("Ссылки") {
                lessons
                flow
                employees
            }
            Section("Дополнительная информация") {
                educationDates
                lastUpdate
                statistics
            }

        }
        .toolbar(content: {
            Button {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.9)) {
                    viewModel.group.favourite = true
                    try! PersistenceController.shared.container.viewContext.save()
                }
            } label: {
                Label(viewModel.group.favourite ? "Убрать из избранных" : "Добавить в избранные",
                      systemImage: viewModel.group.favourite ? "star.circle" : "star.fill")
            }
        })
        .navigationTitle(viewModel.navigationTitle)
        .refreshable {
            await viewModel.update()
        }
    }
    
    @ViewBuilder var information: some View {
        Section(viewModel.group.speciality.name) {
            Form("Аббревиатура", viewModel.group.speciality.abbreviation)
            if let facultyAbbreviation = viewModel.group.speciality.faculty.abbreviation {
                Form("Факультет", facultyAbbreviation)
            }
            
            if viewModel.group.favourite {
                HStack {
                    Text("Псевдоним")
                        .foregroundColor(.primary)
                    Spacer()
                    TextField("Нажмите для ввода", text: $viewModel.nicknameString)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.trailing)
                        .onSubmit {
                            viewModel.submitNickname()
                        }
                }
            }
            
            if let code = viewModel.group.speciality.code {
                Form("Шифр", code)
            }
            Form("Форма обучения", viewModel.group.speciality.educationType.description)
            if let numberOfStudents = viewModel.group.numberOfStudents, numberOfStudents != 0 {
                Form("Количество студентов", String(numberOfStudents))
            }
            if let date = viewModel.group.updateDate {
                Form("Последние обновление", DateFormatters.shared.shortDate.string(from: date))
            }
            
        }
    }
    
    @ViewBuilder var lessons: some View {
        if let lessons = viewModel.group.lessons?.allObjects as? [Lesson], lessons.isEmpty == false {
            NavigationLink {
                LessonsView(viewModel: LessonsViewModel(viewModel.group))
            } label: {
                Label("Расписание группы", systemImage: "calendar")
            }
        }
    }
    
    @ViewBuilder var educationDates: some View {
        if viewModel.group.educationStart != nil || viewModel.group.examsStart != nil {
            if let educationStart = viewModel.group.educationStart, let educationEnd = viewModel.group.educationEnd {
                Button {
                    withAnimation {
                        viewModel.showEducationDuration.toggle()
                    }
                } label: {
                    Form("Семестр", viewModel.showEducationDuration ? "\((educationStart...educationEnd).numberOfDaysBetween()) дней" : "\(DateFormatters.shared.get(.longDate).string(from: educationStart)) – \(DateFormatters.shared.get(.longDate).string(from: educationEnd))")
                }
            }
            if let examsStart = viewModel.group.examsStart, let examsEnd = viewModel.group.examsEnd {
                Button {
                    withAnimation {
                        viewModel.showExamsDuration.toggle()
                    }
                } label: {
                    Form("Сессия", viewModel.showExamsDuration ? "\((examsStart...examsEnd).numberOfDaysBetween()) дней" : "\(DateFormatters.shared.get(.longDate).string(from: examsStart)) – \(DateFormatters.shared.get(.longDate).string(from: examsEnd))")
                }
            }
        }
    }
    @ViewBuilder var lastUpdate: some View {
        HStack {
            Text("Последнее обновление в ИИС")
            Spacer()
            if let date = viewModel.lastUpdateDate {
                Text("\(DateFormatters.shared.longDate.string(from: date))")
                    .foregroundColor(.secondary)
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .gray))
            }
        }
        .task {
            await viewModel.fetchLastUpdateDate()
        }
    }
    
    @ViewBuilder var statistics: some View {
        let lessonsSections = viewModel.group.dateBasedLessonsSectionsForStatistics()
        if lessonsSections.isEmpty == false {
            DisclosureGroup("Статистика") {
                
                let allLessons = Array(lessonsSections.map { $0.lessons }.joined())
                let subjects = Set(allLessons.compactMap { $0.abbreviation }).sorted()
                ForEach(subjects, id: \.self, content: { subject in
                    DisclosureGroup {
                        let subjectLessons = allLessons.filter { $0.abbreviation == subject }
                        let lessonTypes = Set(subjectLessons.map({ $0.lessonType })).sorted { $0.rawValue < $1.rawValue }
                        ForEach(lessonTypes, id: \.self) { lessonType in
                            let lessonTypeLessons = subjectLessons.filter { $0.lessonType == lessonType }
                            var subgroups = Set(lessonTypeLessons.map { $0.subgroup }).sorted()
                            if subgroups.count == 1 {
                                Form(lessonType.abbreviation, String(lessonTypeLessons.count))
                            } else {
                                DisclosureGroup {
                                    let subgroupp = subgroups.removeFirst()
                                    let subgroupLessons = lessonTypeLessons.filter { $0.subgroup == subgroupp }
                                    Form("Общие", String(subgroupLessons.count))
                                    ForEach(subgroups, id: \.self) { subgroup in
                                        let subgroupLessons = lessonTypeLessons.filter { $0.subgroup == subgroup }
                                        Form("\(subgroup)-ая подгруппа", "\(subgroupLessons.count)")
                                    }
                                } label: {
                                    Form(lessonType.abbreviation, String(lessonTypeLessons.count))
                                }
                            }
                        }
                    } label: {
                        Text(subject)
                    }
                    
                })
                
            }
        }
    }
    
    @ViewBuilder var flow: some View {
        if let flow = viewModel.group.flow {
            DisclosureGroup {
                ForEach(flow) { group in
                    NavigationLink(destination: GroupDetailedView(viewModel: GroupViewModel(group))){
                        Text(group.id)
                    }
                }
            } label: {
                Label("Поток", systemImage: "bookmark")
            }
        }
    }
    
    @ViewBuilder var employees: some View {
        if let employees = viewModel.group.employees {
            DisclosureGroup {
                ForEach(employees) { employee in
                    EmployeeView(employee: employee)
                        .background(NavigationLink("", destination: {
                            EmployeeDetailedView(viewModel: EmployeeViewModel(employee))
                        }).opacity(0))
                }
            } label: {
                Label("Преподаватели", systemImage: "person.3")
            }
        }
    }
    
}
