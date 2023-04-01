//
//  AuditoriumsViewModel.swift
//  AuditoriumsViewModel
//
//  Created by Andrej Hurynovič on 25.09.21.
//

import SwiftUI
import Combine

class AuditoriumsViewModel: ObservableObject {
    
    func update() async {
        for auditorium in Auditorium.getAll() {
            PersistenceController.shared.container.viewContext.delete(auditorium)
        }
        await MainActor.run {
            try! PersistenceController.shared.container.viewContext.save()
        }
        await Auditorium.fetchAll()
        await MainActor.run {
            try! PersistenceController.shared.container.viewContext.save()
        }
    }
    
}
