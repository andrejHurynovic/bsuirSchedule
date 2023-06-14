//
//  LessonView.swift
//  LessonView
//
//  Created by Andrej Hurynovič on 14.09.21.
//

import SwiftUI

struct LessonView: View {
    @ObservedObject var lesson: Lesson
    @ObservedObject var viewModel: LessonViewModel
    
    @State var today: Bool
    @State var showFullSubject: Bool = false
    @EnvironmentObject var configuration: LessonViewConfiguration
    
    var lessonTypeColor: Color {
        guard let color = lesson.type?.color else { return Constants.Colors.defaultLessonType }
        return color
    }
    
    init(lesson: Lesson,
         today: Bool) {
        self.lesson = lesson
        self.today = today
        self.viewModel = LessonViewModel(lesson: lesson, today: today)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Button {
                withAnimation {
                    self.showFullSubject.toggle()
                }
            } label: {
                if showFullSubject {
                    fullTitle
                } else {
                    shortTitle
                }
            }
            .foregroundColor(.primary)

            
            mainBody
        }
        .padding()
        .roundedRectangleBackground()
        .opacity(viewModel.passed ? 0.5 : 1.0)
    }
    
    //MARK: - Title
    
    var fullTitle: some View {
        VStack(alignment: .leading) {
            subjectLabel
            Divider()
            HStack(alignment:.top) {
                HStack {
                    lessonType
                    Spacer()
                    auditories
                }
            }
        }
    }
    var shortTitle: some View {
        HStack(alignment: .top) {
            subjectLabel
            Spacer()
            auditories
            lessonType
        }
    }
    
    //MARK: - mainBody
    
    var mainBody: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .bottom) {
                VStack(alignment: .leading) {
//                    Spacer()
                    dates
                    date
                    weeks
                    groups
                    employees
                }
                Spacer()
                time
            }
            note
            
        }
    }
    
    @ViewBuilder var subjectLabel: some View {
        HStack(alignment: .top) {
            subject
            if showFullSubject == true {
                Spacer(minLength: 0)
            }
            subgroup
        }
        .font(.system(.title2,
                      design: .rounded,
                      weight: .bold))
        .foregroundColor(lessonTypeColor)
    }
    
    @ViewBuilder var subject: some View {
        let subjectText = showFullSubject ? lesson.subject : lesson.abbreviation
        if let subject = subjectText, subject.isEmpty == false {
            Text(subject)
                .multilineTextAlignment(.leading)
        }
    }
    
    @ViewBuilder var subgroup: some View {
        if (lesson.subgroup != 0) {
            Image(systemName: String(lesson.subgroup) + ".circle.fill")
        }
    }
    
    @ViewBuilder var auditories: some View {
        if let auditories = lesson.auditories?.allObjects as? [Auditorium], auditories.isEmpty == false {
            HStack(alignment: .top) {
                Image(systemName: Constants.Symbols.auditorium)
                VStack(alignment: .leading) {
                    ForEach(auditories.sorted(by: {$0.name < $1.name}), id: \.self) { auditorium in
                        NavigationLink {
                            AuditoriumDetailedView(auditorium: auditorium)
                        } label: {
                            Text(auditorium.formattedName)
                                .font(.system(.body, design: .rounded))
                                .foregroundColor(Color.primary)
                        }
                        .contextMenu {
                            FavoriteButton(item: auditorium)
                        }
                        
                    }
                }
            }
        }
    }
    
    @ViewBuilder var lessonType: some View {
        if let type = lesson.type {
            
            ZStack {
                if showFullSubject {
                    Text(type.formattedName(abbreviated: false))
                        .multilineTextAlignment(.leading)
                } else {
                    Text(type.formattedName(abbreviated: true))
                        .foregroundColor(lessonTypeColor)
                }
            }
            .font(.system(.body,
                          design: .rounded,
                          weight: .medium))
        }
    }
    
    @ViewBuilder var groups: some View {
        if configuration.showGroups {
            if let groups = self.lesson.groups?.allObjects as? [Group], groups.isEmpty == false {
                HStack(alignment: .top) {
                    Image(systemName: Constants.Symbols.group)
                    Text(groups.description())
                        .contextMenu {
                            ForEach(groups.sorted(by: { String($0.name) < String($1.name) })) { group in
                                Button {
                                    
                                } label: {
                                    Label("\(group.name), \(group.speciality!.abbreviation), \(group.speciality!.faculty!.abbreviation ?? "")", systemImage: Constants.Symbols.group)
                                }
                            }
                        }
                }
            }
        }
    }
    
    @ViewBuilder var employees: some View {
        if configuration.showEmployees {
            if let employees = lesson.employees?.allObjects as? [Employee] {
                ForEach(employees.sorted(by: {$0.lastName < $1.lastName}), id: \.self) { employee in
                    NavigationLink {
                        EmployeeDetailedView(employee: employee)
                    } label: {
                        HStack {
                            if let photo = employee.photo {
                                Image(uiImage: UIImage(data: photo)!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 37.0, height: 37.0)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: Constants.Symbols.employee)
                                    .resizable()
                                    .frame(width: 37.0, height: 37.0)
                            }
                            VStack(alignment: .leading) {
                                Text(employee.lastName)
                                    .font(.system(.body,
                                                  design: .rounded,
                                                  weight: .semibold))
                                Text(employee.formattedName)
                                    .lineLimit(1)
                            }
                        }
                        .foregroundColor(Color.primary)
                    }
                    .contextMenu {
                        FavoriteButton(item: employee)
                    }
                    
                }
            }
        }
    }
    
    @ViewBuilder var dates: some View {
        if configuration.showDates,
           lesson.date == nil,
           let startDate = lesson.startLessonDate,
           let endDate = lesson.endLessonDate {
            Label("\(startDate.formatted(date: .numeric, time: .omitted))-\(endDate.formatted(date: .numeric, time: .omitted))", systemImage: Constants.Symbols.lessonDates)
        }
    }
    @ViewBuilder var date: some View {
        if configuration.showDate,
           let date = lesson.date {
            Label(date.formatted(date: .numeric, time: .omitted), systemImage: Constants.Symbols.lessonDate)
        }
    }
    @ViewBuilder var weeks: some View {
        if configuration.showWeeks,
           let weeksString = lesson.weeksDescription {
            Label(weeksString, systemImage: Constants.Symbols.lessonWeeks)
        }
    }
    
    var time: some View {
        VStack(alignment: .trailing) {
            Text(lesson.timeStart)
                .font(.body)
                .fontWeight(.semibold)
            Text(lesson.timeEnd)
        }
    }
    
    @ViewBuilder var note: some View {
        if let note = lesson.note,
           note.isEmpty == false {
            Divider()
            Text(note)
                .font(.caption)
                .fontWeight(.regular)
                .foregroundColor(.gray)
        }
    }
    
}

struct LessonView_Previews: PreviewProvider {
    static var previews: some View {
        let groups: [Group] = Group.getAll()
        if let group = groups.first(where: { $0.name == "950502" }),
           let lessons = group.lessons?.allObjects as? [Lesson] {
            ScrollView {
                LessonsGridView {
                    ForEach(lessons) { lesson in
                        LessonView(lesson: lesson,
                                   today: false)
                    }
                    .environmentObject(LessonViewConfiguration(showFullSubject: true, showGroups: true, showEmployees: true, showWeeks: true, showDates: true, showDate: true))
                    
                }
                .padding(.horizontal)
            }
            .baseBackground()
        }
    }
}

extension LessonView {
    static var gridItem = GridItem(.adaptive(minimum: 296, maximum: 512))
}
