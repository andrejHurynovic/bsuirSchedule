//
//  SettingsView.swift
//  SettingsView
//
//  Created by Andrej Hurynovič on 29.07.21.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var groupsViewModel = GroupsViewModel()
    @StateObject var employeesViewModel = EmployeesViewModel()
    @StateObject var lessonsStorage = LessonStorage.shared
    @StateObject var facultyStorage = FacultyStorage.shared
    @StateObject var classroomStorage = ClassroomStorage.shared
    @StateObject var specialityStorage = SpecialityStorage.shared

    //@State var mainColor: Color = .accentColor
    @State var lectureColor: Color =  Color(UserDefaults.standard.color(forKey: "lectureColor") ?? .green)
    @State var practiceColor: Color = Color(UserDefaults.standard.color(forKey: "practiceColor") ?? .yellow)
    @State var labWorkColor: Color = Color(UserDefaults.standard.color(forKey: "labWorkColor") ?? .red)
    
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            List {
                Section(content: {
                    //ColorPicker("Основной", selection: $mainColor)
                    ColorPicker("Лекции", selection: $lectureColor)
                        .onChange(of: lectureColor) {newValue in
                            UserDefaults.standard.set(UIColor(newValue), forKey: "lectureColor")
                        }
                    ColorPicker("Практические занятия", selection: $practiceColor)
                        .onChange(of: practiceColor) {newValue in
                            UserDefaults.standard.set(UIColor(newValue), forKey: "practiceColor")
                        }
                    ColorPicker("Лабораторные работы", selection: $labWorkColor)
                        .onChange(of: labWorkColor) {newValue in
                            UserDefaults.standard.set(UIColor(newValue), forKey: "labWorkColor")
                        }
                    Button {
                        showingAlert = true
                    } label: {
                        Label("Сбросить цвета", systemImage: "arrow.uturn.left.circle")
                            .foregroundColor(.red)
                    }.alert("Вы уверены?", isPresented: $showingAlert) {
                        Button ("Сбросить", role: .destructive) {
                            lectureColor = Color.init(red: -4.06846e-06, green: 0.631373, blue: 0.847059)
                            practiceColor = Color.init(red: 1, green: 0.415686, blue: 9.62615e-08)
                            labWorkColor = Color.init(red: 0.745098, green: 0.219608, blue: 0.952942)
                        }
                        Button ("Отмена", role: .cancel) {}
                    }

                }, header: {
                    Text("Оформление")
                })
                    .headerProminence(.increased)
                
                Section(content: {
                    Button {
                        GroupStorage.shared.deleteAll()
                    } label: {
                        Label("Удалить группы (\(groupsViewModel.groups.count))", systemImage: "person.2.circle")
                            .foregroundColor(.red)
                    }
                    Button {
                        EmployeeStorage.shared.deleteAll()
                    } label: {
                        Label("Удалить преподов (\(EmployeeStorage.shared.employees.value.count))", systemImage: "person.circle")
                            .foregroundColor(.red)
                    }
                    Button {
                        lessonsStorage.deleteAll()
                    } label: {
                        Label("Удалить занятия (\(lessonsStorage.lessons.value.count))", systemImage: "book.circle")
                            .foregroundColor(.red)
                    }
                    Button {
                        facultyStorage.deleteAll()
                    } label: {
                        Label("Удалить факультеты (\(facultyStorage.faculties.value.count))", systemImage: "building.2.crop.circle")
                            .foregroundColor(.red)
                    }
                    Button {
                        classroomStorage.deleteAll()
                    } label: {
                        Label("Удалить кабинеты (\(classroomStorage.classrooms.value.count))", systemImage: "house.circle")
                            .foregroundColor(.red)
                    }
                    Button {
                        specialityStorage.deleteAll()
                    } label: {
                        Label("Удалить специальности (\(specialityStorage.specialities.value.count))", systemImage: "folder.circle")
                            .foregroundColor(.red)
                    }
                    
                }, header: {
                    Text("Разработчик")
                })
                    .headerProminence(.increased)
            }
            .navigationTitle("Настройки")
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
