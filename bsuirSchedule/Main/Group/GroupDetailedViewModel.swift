//
//  GroupDetailedViewModel.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 31.05.22.
//

import SwiftUI

class GroupDetailedViewModel: ObservableObject {
    @Published var nicknameString: String = ""
        
    func submitNickname(_ group: Group) {
        let backgroundContext = PersistenceController.shared.container.newBackgroundContext()
        let backgroundGroup = backgroundContext.object(with: group.objectID) as! Group
        
        if nicknameString.isEmpty {
            backgroundGroup.nickname = nil
        } else {
            backgroundGroup.nickname = nicknameString
        }
        
        try! backgroundContext.save()
    }
}
