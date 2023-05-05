//
//  ScheduleNavigationLink.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 5.05.23.
//

import SwiftUI

struct ScheduleNavigationLink<ScheduledType: Scheduled>: View where ScheduledType: ObservableObject {
    @ObservedObject var scheduled: ScheduledType

    var body: some View {
        NavigationLink {
            ScheduleView(scheduled: scheduled)
        } label: {
            Label("Расписание", systemImage: "calendar")
        }
    }
}

struct ScheduleNavigationLink_Previews: PreviewProvider {
    static var previews: some View {
        let groups: [Group] = Group.getAll()
        if let testGroup = groups.first(where: { $0.name == "050502" }) {
            NavigationView {
                Form {
                    ScheduleNavigationLink(scheduled: testGroup)
                }
            }
        }
    }
}
