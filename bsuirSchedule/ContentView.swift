//
//  ContentView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 3.06.21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    var body: some View {
        TabView {
            FavoritesView()
                .tabItem {
                    Label("Избранные", systemImage: "star.fill")
                }
            GroupsView()
                .tabItem {
                    Label("Расписание", systemImage: "calendar")
                }
            EmployeesView()
                .tabItem {
                    Label("Преподаватели", systemImage: "person.3")
                }
            AuditoriumsView()
                .tabItem {
                    Label("Аудитории", systemImage: "mappin")
                }
            SettingsView()
                .tabItem {
                    Label("Настройки", systemImage: "gearshape")
                }
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
