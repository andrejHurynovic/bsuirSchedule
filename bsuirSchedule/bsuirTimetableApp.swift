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
    
    init() {
        if FacultyStorage.shared.faculties.value.isEmpty {
            FacultyStorage.shared.fetch()
        }
        if SpecialityStorage.shared.specialities.value.isEmpty {
            SpecialityStorage.shared.fetch()
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

