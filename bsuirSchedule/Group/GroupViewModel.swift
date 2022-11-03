//
//  GroupViewModel.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 31.05.22.
//

import Foundation
import SwiftUI

class GroupViewModel: ObservableObject {
    
    @Published var group: Group
    
    @Published var lastUpdateDate: Date? = nil

    @Published var showEducationDuration = false
    @Published var showExamsDuration = false
    
    var navigationTitle: String {
        group.id
    }
    
    init(_ group: Group) {
        self.group = group
    }
    
    func update() async {
        guard let updatedGroup = await group.update() else {
            return
        }
        await MainActor.run {
            withAnimation {
                self.group = updatedGroup
            }
            try! PersistenceController.shared.container.viewContext.save()
        }
    }
    
    func fetchLastUpdateDate() async {
        guard let data = try? await URLSession.shared.data(from: FetchDataType.groupUpdateDate.rawValue + String(group.id)) else {
            return
        }
        
        if let date = try? JSONDecoder().decode(LastUpdateDate.self, from: data) {
            await MainActor.run {
                withAnimation {
                    self.lastUpdateDate = date.lastUpdateDate
                }
            }
        }
    }
    
}
