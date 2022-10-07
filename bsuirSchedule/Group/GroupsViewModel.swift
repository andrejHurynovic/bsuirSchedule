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
//        let employees = Employee.getEmployees()
//        await Employee.updatePhotos(for: employees)
//        await Employee.updateEmployees(employees: employees)
        await MainActor.run {
            try! PersistenceController.shared.container.viewContext.save()
        }
    }

}
