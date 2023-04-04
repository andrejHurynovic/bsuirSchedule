//
//  AuditoriumDetailedView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 17.10.21.
//

import SwiftUI

struct AuditoriumDetailedView: View {
    var auditorium: Auditorium
    
    var body: some View {
        List {
            information
            links
            groups
        }
        .navigationTitle(auditorium.formattedName)
    }
    
    
    
    @ViewBuilder var information: some View {
        if auditorium.type != nil || auditorium.capacity != 0 {
            Section("Информация") {
                type
                capacity
            }
        }
    }
    
    @ViewBuilder var type: some View {
        if let type = auditorium.type {
            Form("Тип", type.name)
        }
    }
    
    @ViewBuilder var capacity: some View {
        let capacity = auditorium.capacity
        if capacity != 0 {
            Form("Вместительность", String(capacity))
        }
    }
    
    
    
    @ViewBuilder var links: some View {
        if auditorium.groups != nil || auditorium.department != nil {
            Section("Ссылки") {
                scheduleButton
                department
            }
        }
    }
    
    @ViewBuilder var department: some View {
        if let departmentName = auditorium.department?.name {
            NavigationLink {
                //                DepartmentDetailedView()
            } label: {
                Label(departmentName, systemImage: "person.2.fill")
            }
        }
    }
    
    @ViewBuilder var scheduleButton: some View {
        if auditorium.lessons?.allObjects.isEmpty == false {
            NavigationLink {
                LessonsView(viewModel: LessonsViewModel(auditorium))
            } label: {
                Label("Расписание аудитории", systemImage: "calendar")
            }
        }
    }
    
    
    
    @ViewBuilder var groups: some View {
        if let groups = auditorium.groups, !groups.isEmpty {
            GroupsSectionsView(sections: groups.sections(), groupsCount: groups.count)
        }
    }
    
}
