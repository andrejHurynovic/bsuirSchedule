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
        await MainActor.run {
            try! PersistenceController.shared.container.viewContext.save()
        }
//        let groups = Group.getAll()
//        await Group.updateGroups(groups: groups)
//        await MainActor.run {
//            try! PersistenceController.shared.container.viewContext.save()
//        }
//        let groupsArrays = groups.chunked(into: 1)
//
//        for array in groupsArrays {
//            print(array.count)
//            await Group.updateGroups(groups: array)
//            await MainActor.run {
//                try! PersistenceController.shared.container.viewContext.save()
//            }
//        }
        

    }

}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
