//
//  LessonView.swift
//  LessonView
//
//  Created by Andrej Hurynovič on 14.09.21.
//

import SwiftUI

struct LessonView: View {
    var lesson: Lesson
    
    var showEmployee: Bool
    var showGroups: Bool
    var showWeeks: Bool
    
    var today: Bool
    var passedLesson: Bool {
        return today && lesson.timeRange.upperBound < Date().time
    }
    
    var showSubject: Bool = false
    
    @AppStorage("lectureColor") var lectureColor: Color!
    @AppStorage("practiceColor") var practiceColor: Color!
    @AppStorage("laboratoryColor") var laboratoryColor: Color!
    @AppStorage("consultationColor") var consultationColor: Color!
    @AppStorage("examColor") var examColor: Color!
    
    var color: Color {
        switch lesson.lessonType {
        case .lecture, .remoteLecture:
            return lectureColor
        case .practice, .remotePractice:
            return practiceColor
        case .laboratory, .remoteLaboratory:
            return laboratoryColor
        case .consultation:
            return consultationColor
        case .exam, .candidateText:
            return examColor
        case .none:
            return .gray
        }
    }
    
    
    
    var body: some View {
        VStack(alignment: .leading) {
            if showSubject {
                detailedHeader
            } else {
                minimisedHeader
            }
                footer
        }
        .padding(.all)
        .background(in: RoundedRectangle(cornerRadius: 16))
        .opacity(passedLesson ? 0.5 : 1.0)
        .standardisedShadow()
        
        .contextMenu {
            Text("Добавить задание")
        } preview: {
            LessonView(lesson: lesson, showEmployee: true, showGroups: true, showWeeks: true, today: false, showSubject: true)
        }
    }
    
    //MARK: View
    var detailedHeader: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                subject
                Spacer()
                subgroup
            }
            Divider()
            HStack(alignment:.top) {
                lessonType
                Spacer()
                weeks
                classrooms
            }
        }
    }
    
    var minimisedHeader: some View {
        HStack(alignment: .top) {
            subject
            subgroup
            Spacer()
            weeks
            classrooms
            lessonType
        }
    }
    
    var footer: some View {
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
    
    
    //MARK: Elements
    @ViewBuilder var subject: some View {
        let subject = showSubject ? lesson.subject : lesson.abbreviation
        if let subject = subject, subject.isEmpty == false {
            Text(subject)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
    }
    
    @ViewBuilder var subgroup: some View {
        if (lesson.subgroup != 0) {
            Image(systemName: String(lesson.subgroup) + ".circle.fill")
                .font(.title2.bold())
                .foregroundColor(color)
        }
    }
    
    @ViewBuilder var classrooms: some View {
        if let classrooms = lesson.classrooms?.allObjects as? [Classroom], classrooms.isEmpty == false {
            HStack(alignment: .top) {
                Image(systemName: "mappin")
                VStack(alignment: .leading) {
                    ForEach(classrooms.sorted(by: {$0.name < $1.name}), id: \.self) { classroom in
                        NavigationLink {
                            ClassroomDetailedView(classroom: classroom)
                        } label: {
                            Text(classroom.formattedName(showBuilding: true))
                                .foregroundColor(Color.primary)
                        }
                        .contextMenu {
                            FavoriteButton(classroom.favourite) {
                                classroom.favourite.toggle()
                            }
                        }
                        
                    }
                }
            }
        }
    }
    
    @ViewBuilder var lessonType: some View {
        let lessonType = lesson.lessonType
        let lessonTypeString = showSubject ? lessonType.description : lessonType.abbreviation
        
        if showSubject {
            Text(lessonTypeString)
                .fontWeight(.medium)
        } else {
            if lesson.lessonType != .none {
                Text(lessonTypeString)
                    .fontWeight(.medium)
                    .foregroundColor(color)
            }
        }
        
        
    }
    
    @ViewBuilder var groups: some View {
        if showGroups {
            if let groups = self.lesson.groups?.allObjects as? [Group], groups.isEmpty == false {
                HStack(alignment: .top) {
                    Image(systemName: "person.2.circle")
                    Text(groups.description())
                        .contextMenu {
                            ForEach(groups.sorted(by: { String($0.id) < String($1.id) })) { group in
                                Button {
                                    navigateToGroup(group: group)
                                } label: {
                                    Label("\(group.id!), \(group.speciality.abbreviation), \(group.speciality.faculty.abbreviation ?? "")", systemImage: "person.2.circle")
                                }
                            }
                        }
                }
                .background(groupNavigationLink)
            }
        }
    }
    
    @ViewBuilder var employees: some View {
        if showEmployee {
            if let employees = lesson.employees?.allObjects as? [Employee] {
                ForEach(employees.sorted(by: {$0.lastName! < $1.lastName!}), id: \.self) { employee in
                    
                    NavigationLink {
                        EmployeeDetailedView(viewModel: EmployeeViewModel(employee))
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
                                Text(employee.lastName!)
                                    .font(.body)
                                    .fontWeight(.semibold)
                                Text(employee.firstName! + " " + employee.middleName!)
                                    .lineLimit(1)
                            }
                        }
                        .foregroundColor(Color.primary)
                    }
                    .contextMenu {
                        FavoriteButton(employee.favourite) {
                            employee.favourite.toggle()
                        }
                    }
                    
                }
            }
        }
    }
    
    @ViewBuilder var weeks: some View {
        if showWeeks, let weeksString = lesson.weeksDescription() {
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
        if let linkGroup = linkGroup {
            NavigationLink(destination: GroupDetailedView(viewModel: GroupViewModel(linkGroup)), isActive: $groupLinkActive) {
                EmptyView()
            }
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
        if let testGroup = groups.first(where: { $0.id == "950502" }), let lessons = testGroup.lessons?.allObjects as? [Lesson] {
            
            ForEach(lessons) { lesson in
                LessonView(lesson: lesson, showEmployee: true, showGroups: true, showWeeks: true, today: true, showSubject: true)
                    .padding()
            }
            
        }
    }
}
