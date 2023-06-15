//
//  AuditoriumDetailedView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 17.10.21.
//

import SwiftUI

struct AuditoriumDetailedView: View {
    @ObservedObject var auditorium: Auditorium
    
    var body: some View {
        Form {
            information
            links
            groups
        }
        .navigationTitle(auditorium.formattedName)
        
        .toolbar {
            FavoriteButton(item: auditorium, circle: true)
        }
    }
    
    //MARK: - Information
    
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
            FormView("Тип", type.name)
        }
    }
    @ViewBuilder var capacity: some View {
        let capacity = auditorium.capacity
        if capacity != 0 {
            FormView("Вместительность", String(capacity))
        }
    }
    
    //MARK: - Links
    
    @ViewBuilder var links: some View {
        if auditorium.groups != nil || auditorium.department != nil {
            Section("Ссылки") {
                scheduleButton
                department
            }
        }
    }
    @ViewBuilder var department: some View {
        if let department = auditorium.department {
            NavigationLink {
                DepartmentDetailedView(department: department)
            } label: {
                Label(department.formattedName,
                      systemImage: Constants.Symbols.department)
            }
        }
    }
    @ViewBuilder var scheduleButton: some View {
        if auditorium.lessons?.allObjects.isEmpty == false {
            ScheduleNavigationLink(scheduled: auditorium)
        }
    }
    
    
    
    @ViewBuilder var groups: some View {
        if let groups = auditorium.groups {
            FormGroupsView(groups: groups.sorted(by: {                 $0.name < $1.name
            }))
        }
    }
    
}

struct AuditoriumDetailedView_Previews: PreviewProvider {
    static var previews: some View {
        let auditories: [Auditorium] = Auditorium.getAll()
        ForEach(auditories) { auditorium in
            NavigationView {
                AuditoriumDetailedView(auditorium: auditorium)
            }
        }
    }
}
