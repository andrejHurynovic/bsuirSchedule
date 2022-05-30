//
//  GroupDetaildView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 21.04.22.
//

import SwiftUI

struct GroupDetailedView: View {
    
    @ObservedObject var group: Group
    
    var body: some View {
        List {
                    Section(group.speciality.name) {
                        CoolField("Аббревиатура", group.speciality.abbreviation)
                        CoolField("Факультет", group.speciality.faculty.abbreviation)
                        CoolField("Шифр", group.speciality.code)
                        CoolField("Форма обучения", group.speciality.getEducationTypeDescription())
                        if let educationStart = group.educationStart, let educationEnd = group.educationEnd {
                            CoolField("Семестр",
                                      "\(DateFormatters.shared.dateFormatterddMMyyyy.string(from: educationStart)) – \(DateFormatters.shared.dateFormatterddMMyyyy.string(from: educationEnd)) (\((educationStart...educationEnd).numberOfDaysBetween()))")
                        }
                        if let examsStart = group.examsStart, let examsEnd = group.examsEnd {
                            CoolField("Сессия",
                                      "\(DateFormatters.shared.dateFormatterddMMyyyy.string(from: examsStart)) – \(DateFormatters.shared.dateFormatterddMMyyyy.string(from: examsEnd)) (\((examsStart...examsEnd).numberOfDaysBetween()))")
                        }
                        
                    }
//            DisclosureGroup {
//                let lessons = group.lessons?.allObjects as! [Lesson]
//                let subjects = Set(lessons.compactMap {$0.subject})
//                ForEach(subjects.sorted(), id: \.self) { subject in
//                    let subjectLessons = lessons.filter {$0.subject == subject}
//                    let dates = Array((subjectLessons.map {$0.dates}).joined())
//                    DisclosureGroup {
//                        ForEach(LessonType.allCases, id: \.self) { lessonType in
//                            if let lessons = subjectLessons.filter {$0.lessonType == lessonType}, lessons.isEmpty == false {
//                                let dates = Array((lessons.map {$0.dates}).joined())
//                                CoolField(lessonType.description(), "\(dates.count) пары")
//                            }
//
//                        }
//                    } label: {
//                        CoolField(subject, "\(dates.count) пары")
//                    }
//                }
//            } label: {
//                Text("Статистика")
//            }

        }
        .navigationTitle(group.id)
        .refreshable {
            GroupStorage.shared.fetchDetailed(group)
        }
    }
}

struct CoolField: View  {
    var name: String
    var parameter: String

    init(_ name: String, _ parameter: String) {
        self.name = name
        self.parameter = parameter
    }
    
    var body: some View {
        HStack {
            Text(name)
            Spacer()
            Text(parameter)
                .foregroundColor(.gray)
        }
    }
}

struct GroupDetaildView_Previews: PreviewProvider {
    static var previews: some View {
        GroupDetailedView(group: GroupStorage.shared.groups(ids: ["950503"]).first!)
    }
}
