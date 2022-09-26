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
            lessons
            Section {
                educationDates
                lastUpdate
            }
            statistics
        }
        .navigationTitle(viewModel.navigationTitle)
        .refreshable {
            viewModel.update()
        }
    }
    
    @ViewBuilder var information: some View {
        Section(viewModel.group.speciality.name) {
            Form("Аббревиатура", viewModel.group.speciality.abbreviation)
            Form("Факультет", viewModel.group.speciality.faculty.abbreviation)
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
                .onAppear {
                    viewModel.getUpdateDate()
                }
            Spacer()
            if let date = viewModel.lastUpdateDate {
                Text("\(DateFormatters.shared.longDate.string(from: date))")
                    .foregroundColor(.secondary)
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .gray))
            }
        }
    }
    
    @ViewBuilder var statistics: some View {
        DisclosureGroup("Статистика") {
            let lessonsSections = viewModel.group.lessonsSections()
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
                            Form(lessonType.description(), String(lessonTypeLessons.count))
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
                                Form(lessonType.description(), String(lessonTypeLessons.count))
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

struct GroupDetaildView_Previews: PreviewProvider {
    static var previews: some View {
        GroupDetailedView(viewModel: GroupViewModel(GroupStorage.shared.groups(ids: ["950502"]).first!))
    }
}
