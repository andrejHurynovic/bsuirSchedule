//
//  GroupsViewModel.swift
//  GroupsViewModel
//
//  Created by Andrej Hurynovič on 11.09.21.
//

import SwiftUI
import Combine

class GroupsViewModel: ObservableObject {

    func updateAll() async {
        await Group.fetchAllGroups()
        await MainActor.run {
            try! PersistenceController.shared.container.viewContext.save()
        }
    }

}
