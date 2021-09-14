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
            HStack {
                if showEmployee {
                    if let employee = lesson.employee {
                        HStack {
                            if let photo = employee.photo {
                                Image(uiImage: photo)
                                    .resizable()
                                    .frame(width: 35.0, height: 35.0)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .frame(width: 30.0, height: 30.0)
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
                    HStack {
                        Image(systemName: "person.2.circle")
//                        if let groups = lesson.groups?.allObjects as? [Lesson] {
//                            if let sus = groups.compactMap($0.id) {
//
//                            }
//
//                        }
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
        .background(in: RoundedRectangle(cornerRadius: 16))
        //.shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
        .listRowSeparator(.hidden)
        .edgesIgnoringSafeArea(.all)
    }
}

