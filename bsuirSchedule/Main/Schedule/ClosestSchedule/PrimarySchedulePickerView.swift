//
//  PrimarySchedulePickerView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 10.05.23.
//

import SwiftUI

struct PrimarySchedulePickerView: View {
    @FetchRequest(
        entity: Group.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Group.name, ascending: true)],
        predicate:
            NSPredicate(format: "favorite = true"))
    private var favoriteGroups: FetchedResults<Group>
    @FetchRequest(
        entity: Employee.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Employee.lastName, ascending: true),
            NSSortDescriptor(keyPath: \Employee.firstName, ascending: true)],
        predicate: NSPredicate(format: "favorite = true"))
    private var favoriteEmployees: FetchedResults<Employee>
    @FetchRequest(
        entity: Auditorium.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Auditorium.outsideUniversity, ascending: true),
                          NSSortDescriptor(keyPath: \Auditorium.building, ascending: true),
                          NSSortDescriptor(keyPath: \Auditorium.floor, ascending: true),
                          NSSortDescriptor(keyPath: \Auditorium.name, ascending: true)],
        predicate:
            NSPredicate(format: "favorite = true"))
    private var favoriteAuditories: FetchedResults<Auditorium>
    
    @StateObject private var viewModel = PrimarySchedulesViewModel()
    
    var body: some View {
        Section("Основное расписание") {
            primaryGroupPicker
            primaryEmployeePicker
            primaryAuditoriumPicker
        }
    }
    
    @ViewBuilder private var primaryGroupPicker: some View {
        Picker(selection: $viewModel.primaryGroup, label: Text("Группа")) {
            Text("Нет").tag(nil as String?)
            ForEach(favoriteGroups) { group in
                Text(group.name).tag(group.name as String?)
            }
        }
        Picker(selection: $viewModel.primaryGroupSubgroup, label: Text("Подгруппа")) {
            Text("Любая").tag(nil as Int?)
            Text("Первая").tag(1 as Int?)
            Text("Вторая").tag(2 as Int?)
        }
    }
    @ViewBuilder private var primaryEmployeePicker: some View {
        Picker(selection: $viewModel.primaryEmployee, label: Text("Преподователь")) {
            Text("Нет").tag(nil as Int?)
            ForEach(favoriteEmployees) { employee in
                Text(employee.lastName).tag(Int(employee.id) as Int?)
            }
        }
    }
    @ViewBuilder private var primaryAuditoriumPicker: some View {
        Picker(selection: $viewModel.primaryAuditorium, label: Text("Аудитория")) {
            Text("Нет").tag(nil as String?)
            ForEach(favoriteAuditories) { auditorium in
                Text(auditorium.formattedName).tag(auditorium.formattedName as String?)
            }
        }
    }
}

struct ClosestSchedulePicker_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            PrimarySchedulePickerView()
        }
    }
}
