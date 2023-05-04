//
//  SettingsView.swift
//  SettingsView
//
//  Created by Andrej Hurynovič on 29.07.21.
//

import SwiftUI
import CoreData

struct SettingsView: View {
    @ObservedObject var viewModel = SettingsViewModel()
    
    @FetchRequest(
        entity: Group.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Group.name, ascending: true)],
        predicate:
            NSPredicate(format: "favroite = true"))
    var favroiteGroups: FetchedResults<Group>
    @FetchRequest(
        entity: Employee.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Employee.lastName, ascending: true),
            NSSortDescriptor(keyPath: \Employee.firstName, ascending: true)],
        predicate: NSPredicate(format: "favroite = true"))
    var favroiteEmployees: FetchedResults<Employee>
    @FetchRequest(
        entity: Auditorium.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Auditorium.outsideUniversity, ascending: true),
                          NSSortDescriptor(keyPath: \Auditorium.building, ascending: true),
                          NSSortDescriptor(keyPath: \Auditorium.floor, ascending: true),
                          NSSortDescriptor(keyPath: \Auditorium.name, ascending: true)],
        predicate:
            NSPredicate(format: "favroite = true"))
    var favroiteAuditories: FetchedResults<Auditorium>
    
    var body: some View {
        Form {
            primaryTypePicker
            lessonTypes
            developer
        }
        .navigationTitle("Настройки")
    }
    
    var primaryTypePicker: some View {
        Section("Основное расписание") {
            Picker(selection: viewModel.$primaryTypeValue, label: Text("")) {
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
            case .auditorium:
                primaryAuditoriumPicker
        }
    }
    
    @ViewBuilder var primaryGroupPicker: some View {
        Picker(selection: $viewModel.primaryGroup, label: Text("Выбор")) {
            Text("Нет").tag(nil as String?)
            ForEach(favroiteGroups) { group in
                Text(group.name).tag(group.name as String?)
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
            ForEach(favroiteEmployees) { employee in
                Text(employee.lastName).tag(Int(employee.id) as Int?)
            }
        }
    }
    @ViewBuilder var primaryAuditoriumPicker: some View {
        Picker(selection: $viewModel.primaryAuditorium, label: Text("Выбор")) {
            Text("Нет").tag(nil as String?)
            ForEach(favroiteAuditories) { auditorium in
                Text(auditorium.formattedName).tag(auditorium.formattedName as String?)
            }
        }
    }
    
    var lessonTypes: some View {
        NavigationLink {
            LessonTypesView()
        } label: {
            Label("Типы занятий", systemImage: "tray.circle")
                .foregroundColor(.accentColor)
        }
    }
    
    var developer: some View {
        Section("Разработчик") {
            NavigationLink {
                DeveloperView()
            } label: {
                Label("Разработчик", systemImage: "lock.open.laptopcomputer")
                    .foregroundColor(.accentColor)
            }
        }
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
    }
}
