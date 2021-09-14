//
//  SettingsView.swift
//  SettingsView
//
//  Created by Andrej Hurynovič on 29.07.21.
//

import SwiftUI

struct SettingsView: View {
    @State private var showingAlert = false
    
    //@State var mainColor: Color = .accentColor
    @State var lectureColor: Color =  Color(UserDefaults.standard.color(forKey: "lectureColor") ?? .green)
    @State var practiceColor: Color = Color(UserDefaults.standard.color(forKey: "practiceColor") ?? .yellow)
    @State var labWorkColor: Color = Color(UserDefaults.standard.color(forKey: "labWorkColor") ?? .red)
    
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
                            lectureColor = .green
                            practiceColor = .yellow
                            labWorkColor = .red
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
                        Label("Удалить группы (\(GroupStorage.shared.groups.value.count))", systemImage: "person.2.circle")
                            .foregroundColor(.red)
                    }
                    Button {
                        EmployeeStorage.shared.deleteAll()
                    } label: {
                        Label("Удалить преподов (\(EmployeeStorage.shared.employees.value.count))", systemImage: "person.circle")
                            .foregroundColor(.red)
                    }
                    Button {
                        LessonStorage.shared.deleteAll()
                    } label: {
                        Label("Удалить занятия (\(LessonStorage.shared.lessons.value.count))", systemImage: "person.circle")
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
