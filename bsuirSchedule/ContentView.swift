//
//  ContentView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 3.06.21.
//

import SwiftUI

struct ContentView: View {
    @StateObject var compoundSchedulePickerViewModel = CompoundSchedulePickerViewModel()
    
    var body: some View {
        HomeView()
            .sheet(isPresented: $compoundSchedulePickerViewModel.showCompoundSchedulePickerSheet, content: {
                CompoundSchedulePickerSheet()
            })
            .environmentObject(compoundSchedulePickerViewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
