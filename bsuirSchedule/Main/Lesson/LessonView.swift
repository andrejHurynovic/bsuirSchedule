//
//  LessonView.swift
//  LessonView
//
//  Created by Andrej Hurynovič on 14.09.21.
//

import SwiftUI

struct LessonView: View {
    @ObservedObject var lesson: Lesson
    @ObservedObject var settings: LessonViewSettings
    
    var today: Bool
    var passedLesson: Bool { today && lesson.timeRange.upperBound < Date().time }
    
    var lessonTypeColor: Color {
        guard let color = lesson.type?.color else { return .primary }
        return color
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if settings.showAbbreviation {
                shortTitle
            } else {
                fullTitle
            }
                mainBody
        }
        .padding()
        .roundedRectangleBackground()
        .opacity(passedLesson ? 0.5 : 1.0)

        .contextMenu {
            Text("Добавить задание")
            Button("Удалить занятие") {
                PersistenceController.shared.container.viewContext.delete(lesson)
                try! PersistenceController.shared.container.viewContext.save()
            }
        } preview: {
            LessonView(lesson: lesson,
                       settings: LessonViewSettings(showAbbreviation: false,
                                                    showGroups: true,
                                                    showEmployees: true,
                                                    showWeeks: true,
                                                    showDates: true,
                                                    showDate: true),
                       today: false)
        }
        
       
    }
    
    //MARK: - Title
    
    var fullTitle: some View {
        VStack(alignment: .leading) {
            subjectLabel
            Divider()
            HStack(alignment:.top) {
                lessonType
                Spacer()
                weeks
                auditories
            }
        }
    }
    var shortTitle: some View {
        HStack(alignment: .top) {
            subjectLabel
            Spacer()
            weeks
            auditories
            lessonType
        }
    }
    
    //MARK: - mainBody
    
    var mainBody: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading) {
                Spacer()
                groups
                employees
                note
            }
            Spacer()
            time
        }
    }
    
    //MARK: - subjectLabel
    
    @ViewBuilder var subjectLabel: some View {
        HStack(alignment: .top) {
            subject
            if settings.showAbbreviation == false {
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
        let subjectText = settings.showAbbreviation ? lesson.abbreviation : lesson.subject
        if let subject = subjectText, subject.isEmpty == false {
            Text(subject)
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
                Image(systemName: "mappin")
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
                if settings.showAbbreviation {
                    Text(type.formattedName(abbreviated: true))
                        .foregroundColor(lessonTypeColor)
                } else {
                    Text(type.formattedName(abbreviated: false))
                }
            }
                .font(.system(.body,
                              design: .rounded,
                              weight: .medium))
        }
    }
    
    @ViewBuilder var groups: some View {
        if settings.showGroups {
            if let groups = self.lesson.groups?.allObjects as? [Group], groups.isEmpty == false {
                HStack(alignment: .top) {
                    Image(systemName: "person.2.circle")
                    Text(groups.description())
                        .contextMenu {
                            ForEach(groups.sorted(by: { String($0.name) < String($1.name) })) { group in
                                Button {
                                    navigateToGroup(group: group)
                                } label: {
                                    Label("\(group.name), \(group.speciality!.abbreviation), \(group.speciality!.faculty!.abbreviation ?? "")", systemImage: "person.2.circle")
                                }
                            }
                        }
                }
                .background(groupNavigationLink)
            }
        }
    }
    
    @ViewBuilder var employees: some View {
        if settings.showEmployees {
            if let employees = lesson.employees?.allObjects as? [Employee] {
                ForEach(employees.sorted(by: {$0.lastName < $1.lastName}), id: \.self) { employee in
                    NavigationLink {
                        EmployeeDetailedView(employee: employee)
                    } label: {
                        HStack {
                            if let photo = employee.photo {
                                Image(uiImage: UIImage(data: photo)!)
                                    .resizable()
                                    .frame(width: 37.0, height: 37.0)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "person.circle.fill")
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
    
    @ViewBuilder var weeks: some View {
        if settings.showWeeks, let weeksString = lesson.weeksDescription {
            Label(weeksString, systemImage: "calendar")
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
        if let note = lesson.note {
            Text(note)
                .font(.caption)
                .fontWeight(.regular)
                .foregroundColor(.gray)
        }
    }
    
    @ViewBuilder var groupNavigationLink: some View {
        if let _ = linkGroup {
//            NavigationLink(destination: GroupDetailedView(viewModel: GroupViewModel(linkGroup)), isActive: $groupLinkActive) {
//                EmptyView()
//            }
        }
    }
    
   @State var groupLinkActive = false
   @State var linkGroup: Group? = nil
    
    func navigateToGroup(group: Group) {
        linkGroup = group
        groupLinkActive = true
    }
    
}

struct LessonView_Previews: PreviewProvider {
    static var previews: some View {
        let groups = Group.getAll()
        if let group = groups.first(where: { $0.name == "950502" }), let lessons = group.lessons?.allObjects as? [Lesson] {
            
            ForEach(lessons) { lesson in
                LessonView(lesson: lesson,
                           settings: Group.defaultLessonSettings(),
                           today: true)
                    .padding()
            }
            
        }
    }
}
