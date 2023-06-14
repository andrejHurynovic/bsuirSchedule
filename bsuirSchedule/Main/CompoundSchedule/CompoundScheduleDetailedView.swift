//
//  CompoundScheduleDetailedView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 13.06.23.
//

import SwiftUI

struct CompoundScheduleDetailedView: View {
    @ObservedObject var compoundSchedule: CompoundSchedule

    var body: some View {
        Form {
            ScheduleNavigationLink(scheduled: compoundSchedule)
            
            if let groups = compoundSchedule.groups?.allObjects as? [Group],
               groups.isEmpty == false {
                FormGroupsView(groups: groups)
            }
            if let employees = compoundSchedule.employees?.allObjects as? [Employee],
               employees.isEmpty == false {
                Section("Преподаватели") {
                    EmployeesFormView(employees: employees)
                }
            }
            if let auditories = compoundSchedule.auditories?.allObjects as? [Auditorium],
               auditories.isEmpty == false {
                Section("Аудитории") {
                    AuditoriesFormView(auditories: auditories)
                }
            }
        }
        .navigationTitle(compoundSchedule.name!)
    }
} 

struct CompoundScheduleDetailedView_Previews: PreviewProvider {
    static var previews: some View {
        if let compoundSchedule : CompoundSchedule = CompoundSchedule.getAll().randomElement() {
            NavigationView {
                CompoundScheduleDetailedView(compoundSchedule: compoundSchedule)
                    .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
            }
        }
    }
    
}
