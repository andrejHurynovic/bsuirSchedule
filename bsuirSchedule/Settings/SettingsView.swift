//
//  SettingsView.swift
//  SettingsView
//
//  Created by Andrej Hurynovič on 29.07.21.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel = SettingsViewModel()
    
    @FetchRequest(
        entity: Group.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Group.id, ascending: true)],
        predicate:
            NSPredicate(format: "favourite = true"))
    var favouriteGroups: FetchedResults<Group>
    @FetchRequest(
        entity: Employee.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Employee.lastName, ascending: true),
            NSSortDescriptor(keyPath: \Employee.firstName, ascending: true)],
        predicate: NSPredicate(format: "favourite = true"))
    var favouriteEmployees: FetchedResults<Employee>
    @FetchRequest(
        entity: Classroom.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Classroom.originalName, ascending: true)],
        predicate:
            NSPredicate(format: "favourite = true"))
    var favouriteClassrooms: FetchedResults<Classroom>
    
    var body: some View {
        NavigationView {
            List {
                primaryTypePicker
                colors
                developer
            }
            .navigationTitle("Настройки")
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    var primaryTypePicker: some View {
        Section("Основное расписание") {
            Picker(selection: viewModel.$primaryTypeValue, label: Text("Select Gender")) {
                ForEach(PrimaryType.allCases, id: \.self) { type in
                    Text(type.description).tag(type.rawValue)
                }
            }.pickerStyle(SegmentedPickerStyle())
            primaryPickers
        }
    }
    
    @ViewBuilder var primaryPickers: some View {
        switch viewModel.primaryType {
        case .group:
            primaryGroupPicker
        case .employee:
            primaryEmployeePicker
        case .classroom:
            primaryClassroomPicker
        }
    }
    
    @ViewBuilder var primaryGroupPicker: some View {
            Picker(selection: $viewModel.primaryGroup, label: Text("Выбор")) {
                Text("Нет").tag(nil as String?)
                ForEach(favouriteGroups) { group in
                    Text(group.id).tag(group.id as String?)
                }
            }
            Picker(selection: $viewModel.primaryGroupSubgroup, label: Text("Подгруппа")) {
                Text("Любая").tag(nil as Int?)
                Text("Первая").tag(1 as Int?)
                Text("Вторая").tag(2 as Int?)
            }
    }
    @ViewBuilder var primaryEmployeePicker: some View {
            Picker(selection: $viewModel.primaryEmployee, label: Text("Выбор")) {
                Text("Нет").tag(nil as Int?)
                ForEach(favouriteEmployees) { employee in
                    Text(employee.lastName).tag(Int(employee.id) as Int?)
                }
            }
    }
    @ViewBuilder var primaryClassroomPicker: some View {
            Picker(selection: $viewModel.primaryClassroom, label: Text("Выбор")) {
                Text("Нет").tag(nil as String?)
                ForEach(favouriteClassrooms) { classroom in
                    Text(classroom.formattedName(showBuilding: true)).tag(classroom.originalName as String?)
                }
            }
    }
    
    @ViewBuilder var colors: some View {
        Section("Цвета") {
            ColorPicker("Основной", selection: $viewModel.mainColor)
            ColorPicker("Лекции", selection: $viewModel.lectureColor)
            ColorPicker("Практические занятия", selection: $viewModel.practiceColor)
            ColorPicker("Лабораторные работы", selection: $viewModel.laboratoryColor)
            ColorPicker("Косультации", selection: $viewModel.consultationColor)
            ColorPicker("Экзамены", selection: $viewModel.examColor)
            
            Button {
                viewModel.showingRestoreDefaultColorsAlert = true
            } label: {
                Label("Сбросить цвета", systemImage: "arrow.uturn.left.circle")
                    .foregroundColor(.red)
            }.alert("Вы уверены?", isPresented: $viewModel.showingRestoreDefaultColorsAlert) {
                Button ("Сбросить", role: .destructive) {
                    viewModel.restoreDefaultColors()
                }
                Button ("Отмена", role: .cancel) {}
            }
            
        }
    }
    
    @ViewBuilder var developer: some View {
        Section("Разработчик") {
            NavigationLink {
                DeveloperView()
            } label: {
                Label("Разработчик", systemImage: "lock.open.laptopcomputer")
                    .foregroundColor(.blue)
            }
        }
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
        
    }
}
