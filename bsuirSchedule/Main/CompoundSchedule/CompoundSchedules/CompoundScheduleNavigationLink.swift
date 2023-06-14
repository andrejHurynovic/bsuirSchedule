//
//  CompoundScheduleNavigationLink.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 14.06.23.
//

import SwiftUI

struct CompoundScheduleNavigationLink: View {
    @ObservedObject var compoundSchedule: CompoundSchedule
    
    var body: some View {
        NavigationLink {
            ScheduleView(scheduled: compoundSchedule)
        } label: {
            CompoundScheduleView(compoundSchedule: compoundSchedule)
                .contextMenu {
                    DeleteButton {
                        let backgroundContext = PersistenceController.shared.container.newBackgroundContext()
                        guard let backgroundCompoundSchedule = backgroundContext.object(with: compoundSchedule.objectID) as? CompoundSchedule else { return }
                        backgroundContext.delete(backgroundCompoundSchedule)
                        try? backgroundContext.save()
                    }
                }
        }

    }
}

struct CompoundScheduleNavigationLink_Previews: PreviewProvider {
    static var previews: some View {
        if let compoundSchedule: CompoundSchedule = CompoundSchedule.getAll().randomElement() {
            CompoundScheduleNavigationLink(compoundSchedule: compoundSchedule)
        }
    }
}
