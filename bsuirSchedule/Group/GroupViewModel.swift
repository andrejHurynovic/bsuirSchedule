//
//  GroupViewModel.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 31.05.22.
//

import Foundation
import Combine
import SwiftUI

class GroupViewModel: ObservableObject {
    
    @Published var group: Group
    
    @Published var lastUpdateDate: Date? = nil
    var cancellables = Set<AnyCancellable>()

    @Published var showEducationDuration = false
    @Published var showExamsDuration = false
    
    var navigationTitle: String {
        group.id
    }
    
    init(_ group: Group) {
        self.group = group
//        let cancellable = GroupStorage.shared.values.eraseToAnyPublisher().sink(receiveValue: { groups in
//            withAnimation {
//                self.group = groups.first { group in    
//                    self.group.id == group.id
//                }!
//            }
//        })
//        cancellables.insert(cancellable)
    }
    
    func getUpdateDate() {
        let cancellable = FetchManager.shared.fetch(dataType: .groupUpdateDate, argument: group.id) { [weak self] (date: LastUpdateDate) -> () in
            self?.lastUpdateDate = date.lastUpdateDate
            
            if let groupUpdateDate = self?.group.updateDate, groupUpdateDate < date.lastUpdateDate{
                self?.update()
            }
        }
        cancellables.insert(cancellable)
    }
    
    func update() {
        GroupStorage.shared.update(group)
    }
    
}
