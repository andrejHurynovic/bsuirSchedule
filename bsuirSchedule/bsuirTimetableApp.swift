//
//  bsuirScheduleApp.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 3.06.21.
//

import SwiftUI

@main
struct bsuirScheduleApp: App {
//    @AppStorage("mainColor") var color: Color!
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
//                .tint(color)
//                .accentColor(color)
        }
    }
}

