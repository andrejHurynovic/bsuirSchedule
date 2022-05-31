//
//  GroupViewModel.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 31.05.22.
//

import Foundation
import Combine

class GroupViewModel: ObservableObject {
    
    @Published var group: Group
    
    @Published var lastUpdateDate: Date? = nil
    var cancellable: AnyCancellable? = nil
    
    @Published var showEducationDuration = false
    @Published var showExamsDuration = false
    
    var navigationTitle: String {
        group.id
    }
    
    init(_ group: Group) {
        self.group = group
        
        getUpdateDate()
    }
    
    func getUpdateDate() {
        cancellable = FetchManager.shared.fetch(dataType: .groupUpdateDate, argument: group.id) { [weak self] (date: LastUpdateDate) -> () in
            self?.lastUpdateDate = date.lastUpdateDate
            
            if let groupUpdateDate = self?.group.updateDate, groupUpdateDate < date.lastUpdateDate{
                self?.update()
            }
        }
    }
    
    func update() {
        GroupStorage.shared.update(group)
    }
    
}
