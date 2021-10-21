//
//  bsuirScheduleApp.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 3.06.21.
//

import SwiftUI

@main
struct bsuirScheduleApp: App {
    let persistenceController = PersistenceController.shared
        
    @AppStorage("mainColor") var color = ColorManager.shared.mainColor

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .tint(color)
                .accentColor(color)
        }
    }
}

