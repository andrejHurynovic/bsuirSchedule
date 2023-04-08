//
//  GroupsViewModel.swift
//  GroupsViewModel
//
//  Created by Andrej Hurynovič on 11.09.21.
//

import SwiftUI

class GroupsViewModel: ObservableObject {

    func update() async {
        await Group.fetchAll()
        let groups = Group.getAll()
        await Group.updateGroups(groups: groups)
        await MainActor.run {
            try! PersistenceController.shared.container.viewContext.save()
        }

    }

}
