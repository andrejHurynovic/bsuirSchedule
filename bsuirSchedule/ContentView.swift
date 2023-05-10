//
//  ContentView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 3.06.21.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("tintColor") var tintColor: Color = Color.accentColor
    
    var body: some View {
        HomeView()
            .tint(tintColor)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
