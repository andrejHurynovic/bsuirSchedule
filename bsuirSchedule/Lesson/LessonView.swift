//
//  LessonView.swift
//  LessonView
//
//  Created by Andrej Hurynovič on 14.09.21.
//

import SwiftUI

struct LessonView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var lesson: Lesson
    var showEmployee: Bool
    var showGroups: Bool
    
    var color: Color
    var showToday: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                subject
                Spacer()
                classrooms
                lessonType
            }
            
            HStack(alignment: .bottom) {
                VStack(alignment: .leading) {
                    Spacer()
                    groups
                    employees
                }
                Spacer()
                time
            }
            note
        }
        //не работает, так как у нас новая система дат теперь
//        .opacity((showToday && lesson.date == .orderedDescending) ? 0.5 : 1)
        .padding(.all)
        .listRowSeparator(.hidden)
        .background(in: RoundedRectangle(cornerRadius: 16))
        .clipped()
        .standardisedShadow()
    }
    
    var subject: some View {
        HStack {
            Text(lesson.abbreviation!)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            if (lesson.subgroup != 0) {
                Image(systemName: String(lesson.subgroup) + ".circle.fill")
                    .font(.title2.bold())
                    .foregroundColor(color)
            }
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
    
    var lessonType: some View {
        Text(lesson.getLessonTypeAbbreviation())
            .fontWeight(.medium)
            .foregroundColor(color)
    }
    
    @ViewBuilder var groups: some View {
        if showGroups {
            HStack(alignment: .top) {
                Image(systemName: "person.2.circle")
                if let groups = self.lesson.groups?.allObjects as? [Group] {
                    if let groupsIDs = groups.map({$0.id!}).sorted() {
                        Text(groupsString(groupsIDs))
                            .contextMenu {
                                ForEach(groups.sorted(by: {String($0.id) < String($1.id)})) { group in
                                    NavigationLink(destination: LessonsView(viewModel: LessonsViewModel(group))) {
                                        Label("\(group.id!), \(group.speciality.abbreviation), \(group.speciality.faculty.abbreviation ?? "")", systemImage: "person.2.circle")
                                    }
                                }
                            }
                    }
                }
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
                                    .frame(width: 35.0, height: 35.0)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 35.0, height: 35.0)
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
    
    var time: some View {
        VStack(alignment: .trailing) {
            Text(lesson.timeStart)
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
    
    
    
    func groupsString(_ groups: [String]) -> String {
        if groups.isEmpty {
            return ""
        }
        if groups.count == 1 {
            return groups.first!
        }
        var groups = groups
        var nearGroups: [String] = []
        var finalGroups: [String] = []
        
        repeat {
            nearGroups.removeAll()
            nearGroups.append(groups.removeFirst())
            if groups.isEmpty == false {
                while groups.isEmpty == false, Int(groups.first!)! - Int(nearGroups.last!)! == 1 {
                    nearGroups.append(groups.removeFirst())
                }
                if nearGroups.count > 1 {
                    finalGroups.append("\(nearGroups.first!)-\((String(nearGroups.last!)).last!)")
                } else {
                    finalGroups.append(String(nearGroups.first!))
                }
                
            } else {
                finalGroups.append(String(nearGroups.first!))
            }
            
        } while (groups.isEmpty == false)
        return finalGroups.joined(separator: ", ")
    }
}

