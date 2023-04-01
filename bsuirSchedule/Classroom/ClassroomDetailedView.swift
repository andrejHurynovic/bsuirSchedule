//
//  ClassroomDetailedView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 17.10.21.
//

import SwiftUI

struct ClassroomDetailedView: View {
    var classroom: Classroom
    
    var body: some View {
        List {
            information
            links
            groups
        }
        .navigationTitle(classroom.formattedName(showBuilding: true))
    }
    
    @ViewBuilder var information: some View {
        Section("Информация") {
            type
            capacity
        }
    }
    
    @ViewBuilder var type: some View {
        if let type = classroom.type {
            Form("Тип", type.name)
        }
    }
    
    @ViewBuilder var capacity: some View {
        let capacity = classroom.capacity
        if capacity != 0 {
            Form("Вместительность", String(capacity))
        }
    }
    
    
    
    @ViewBuilder var links: some View {
        Section("Ссылки") {
            scheduleButton
            department
        }
    }
    
    @ViewBuilder var department: some View {
        if let departmentName = classroom.department?.name {
            NavigationLink {
                //                DepartmentDetailedView()
            } label: {
                Label(departmentName, systemImage: "person.2.fill")
            }
        }
    }
    
    @ViewBuilder var scheduleButton: some View {
        if classroom.lessons?.allObjects.isEmpty == false {
            NavigationLink {
                LessonsView(viewModel: LessonsViewModel(classroom))
            } label: {
                Label("Расписание кабинета", systemImage: "calendar")
            }
        }
    }
    
    
    
    @ViewBuilder var groups: some View {
        if let groups = classroom.groups, !groups.isEmpty {
            GroupsSectionsView(sections: groups.sections(), groupsCount: groups.count)
        }
    }
    
}
