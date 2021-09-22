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
    
    var body: some View {
        VStack {
            HStack {
                HStack {
                    Text(lesson.subject!)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(lesson.getColor())
                    if (lesson.subgroup != 0) {
                        Label("", systemImage: String(lesson.subgroup) + ".circle")
                            .font(.title2.bold())
                    }
                }
                Spacer()
                if let auditory = lesson.auditory {
                    Label(auditory, systemImage: "mappin.circle")
                }
                
                switch(lesson.lessonType) {
                case .lecture:
                    Text("ЛК")
                        .fontWeight(.medium)
                        .foregroundColor(lesson.getColor())
                case .practice:
                    Text("ПЗ")
                        .fontWeight(.medium)
                        .foregroundColor(lesson.getColor())
                case .laboratory:
                    Text("ЛР")
                        .fontWeight(.medium)
                        .foregroundColor(lesson.getColor())
                }
            }
            HStack(alignment: .bottom) {
                if showEmployee {
                    if let employee = lesson.employee {
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
                            }
                        }
                        .background(NavigationLink(destination: {
                            EmployeeDetailedView(employee: employee)
                        }, label: {}) .opacity(0)
                        )
                        
                    }
                } else {
                    HStack(alignment: .top) {
                        Image(systemName: "person.2.circle")
                        if let groups = self.lesson.groups?.allObjects as? [Group] {
                            if let groupsIDs = groups.map({$0.id}) as? [String] {
                                Text(groupsIDs.sorted().joined(separator: ", "))
                            }
                        }
                    }
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text(lesson.timeStart!)
                        .fontWeight(.semibold)
                    Text(lesson.timeEnd!)
                    
                }
            }
        }
        .padding(.all)
        .listRowSeparator(.hidden)
        .background(in: RoundedRectangle(cornerRadius: 16))
        .clipped()
        .shadow(color: colorScheme == .dark ? Color(#colorLiteral(red: 255, green: 255, blue: 255, alpha: 0.2)) : Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1)), radius: 5, x: 0, y: 0)
    }
}

