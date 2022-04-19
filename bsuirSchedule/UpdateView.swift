//
//  UpdateView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 24.02.22.
//

import SwiftUI
import Combine


struct UpdateView: View {
    @ObservedObject var facultyStorage = FacultyStorage.shared
    @ObservedObject var specialityStorage = SpecialityStorage.shared
    @ObservedObject var classroomStorage = ClassroomStorage.shared
    @ObservedObject var groupStorage = GroupStorage.shared
    @ObservedObject var employeeStorage = EmployeeStorage.shared
    
    var body: some View {
        List {
            Button("Обновить всё") {
                EmployeeStorage.shared.deleteAll()
                GroupStorage.shared.deleteAll()
                LessonStorage.shared.deleteAll()
                ClassroomStorage.shared.deleteAll()
                SpecialityStorage.shared.deleteAll()
                FacultyStorage.shared.deleteAll()
                facultyStorage.fetch()
            }
            HStack(alignment: .center) {
                Text("Факультеты: ")
                Spacer()
                if facultyStorage.tempValues.count == 0 {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                } else {
                    Text(String(facultyStorage.tempValues.count))
                        .foregroundColor(.gray)
                }
            }
            .onChange(of: facultyStorage.tempValues.count) { newValue in
                specialityStorage.fetch()
            }
            HStack(alignment: .center) {
                Text("Специальности: ")
                Spacer()
                if specialityStorage.tempValues.count == 0 {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                } else {
                    Text(String(specialityStorage.tempValues.count))
                        .foregroundColor(.gray)
                }
            }
            .onChange(of: specialityStorage.tempValues.count) { newValue in
                classroomStorage.fetch()
            }
            HStack(alignment: .center) {
                Text("Кабинеты: ")
                Spacer()
                if classroomStorage.tempValues.count == 0 {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                } else {
                    Text(String(classroomStorage.tempValues.count))
                        .foregroundColor(.gray)
                }
            }
            .onChange(of: classroomStorage.tempValues.count) { newValue in
                employeeStorage.fetch()
            }
            HStack(alignment: .center) {
                Text("Преподаватели: ")
                Spacer()
                if employeeStorage.tempValues.count == 0 {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                } else {
                    Text("\(employeeStorage.tempValues.filter({$0.updateDate != nil}).count) из \(employeeStorage.tempValues.count)")
                        .foregroundColor(.gray)
                }
            }
            .onChange(of: employeeStorage.tempValues.filter({$0.updateDate != nil}).count) { newValue in
                if newValue == employeeStorage.tempValues.count, newValue != 0 {
                    groupStorage.fetch()
                }
            }
            HStack(alignment: .center) {
                Text("Группы: ")
                Spacer()
                if groupStorage.tempValues.count == 0 {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                } else {
                    Text("\(groupStorage.tempValues.filter({$0.lastUpdateDate != nil}).count) из \(groupStorage.tempValues.count)")
                        .foregroundColor(.gray)
                }
            }
        }
        
    }
}

//struct DoctorBonerMaxima_Previews: PreviewProvider {
//    static var previews: some View {
////        DoctorBonerMaxima()
//    }
//}
