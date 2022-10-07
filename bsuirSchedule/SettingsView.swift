//
//  SettingsView.swift
//  SettingsView
//
//  Created by Andrej Hurynovič on 29.07.21.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var groupsViewModel = GroupsViewModel()
    @ObservedObject var employeesViewModel = EmployeesViewModel()
    @ObservedObject var lessonsStorage = LessonStorage.shared
    @ObservedObject var facultyStorage = FacultyStorage.shared
    @ObservedObject var classroomStorage = ClassroomStorage.shared
    @ObservedObject var specialityStorage = SpecialityStorage.shared
    
    @StateObject var colorManager = DesignManager.shared
    
    @State private var showingAlert = false
    
    @AppStorage("primaryGroup") var primaryGroup: String?
    @AppStorage("primaryGroupSubgroup") var primaryGroupSubgroup: Int?
    
    var body: some View {
        NavigationView {
            List {
                primaryGroupSection
                colors
                developer
            }
            .navigationTitle("Настройки")
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    
    @ViewBuilder var primaryGroupSection: some View {
        Section("Основная группа") {
            //            Picker(selection: $primaryGroup, label: Text("Группа")) {
            //                Text("Нет").tag(nil as String?)
            //                ForEach(GroupStorage.shared.favorites()) { group in
            //                    Text(group.id).tag(group.id as String?)
            //                }
            //            }
            Picker(selection: $primaryGroupSubgroup, label: Text("Подгруппа")) {
                Text("Любая").tag(nil as Int?)
                Text("Первая").tag(1 as Int?)
                Text("Вторая").tag(2 as Int?)
            }
        }
    }
    
    @ViewBuilder var colors: some View {
        Section("Цвета") {
            ColorPicker("Основной", selection: $colorManager.mainColor)
                .onChange(of: colorManager.mainColor, perform: { newValue in
                    print(newValue)
                })
            ColorPicker("Лекции", selection: $colorManager.lectureColor)
            ColorPicker("Практические занятия", selection: $colorManager.practiceColor)
            ColorPicker("Лабораторные работы", selection: $colorManager.laboratoryColor)
            ColorPicker("Косультации", selection: $colorManager.consultationColor)
                .onChange(of: colorManager.consultationColor, perform: { newValue in
                    print(newValue)
                })
            ColorPicker("Экзамены", selection: $colorManager.examColor)
                .onChange(of: colorManager.examColor, perform: { newValue in
                    print(newValue)
                })
            Button {
                showingAlert = true
            } label: {
                Label("Сбросить цвета", systemImage: "arrow.uturn.left.circle")
                    .foregroundColor(.red)
            }.alert("Вы уверены?", isPresented: $showingAlert) {
                Button ("Сбросить", role: .destructive) {
                    colorManager.restoreDefaults()
                }
                Button ("Отмена", role: .cancel) {}
            }
            
        }
    }
    
    @ViewBuilder var developer: some View {
        Button {
            WeekStorage.shared.fetch()
        } label: {
            Text("Неделя")
        }
        Section("Разработчик") {
            NavigationLink("UpdateView") {
                UpdateView()
            }
            
            
            Button {
                FacultyStorage.shared.fetch()
            } label: {
                Text("Факультеты")
            }
            Button {
                SpecialityStorage.shared.fetch()
            } label: {
                Text("Специальности")
            }
            Button {
                ClassroomStorage.shared.fetch()
            } label: {
                Text("Кабинеты")
            }
            //            Button {
            //                GroupStorage.shared.deleteAll()
            //            } label: {
            //                Label("Удалить группы (\(groupsViewModel.groups.count))", systemImage: "person.2.circle")
            //                    .foregroundColor(.red)
            //        }
//            Button {
//                EmployeeStorage.shared.deleteAll()
//            } label: {
//                Label("Удалить преподов (\(EmployeeStorage.shared.values.value.count))", systemImage: "person.circle")
//                    .foregroundColor(.red)
//            }
            Button {
                lessonsStorage.deleteAll()
            } label: {
                Label("Удалить занятия (\(lessonsStorage.values.value.count))", systemImage: "book.circle")
                    .foregroundColor(.red)
            }
            Button {
                FacultyStorage.shared.deleteAll()
            } label: {
                Label("Удалить факультеты (\(facultyStorage.values.value.count))", systemImage: "building.2.crop.circle")
                    .foregroundColor(.red)
            }
            Button {
                classroomStorage.deleteAll()
            } label: {
                Label("Удалить кабинеты (\(classroomStorage.values.value.count))", systemImage: "house.circle")
                    .foregroundColor(.red)
            }
            Button {
                specialityStorage.deleteAll()
            } label: {
                Label("Удалить специальности (\(specialityStorage.values.value.count))", systemImage: "folder.circle")
                    .foregroundColor(.red)
            }
        }
    }
    
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
        
    }
}
