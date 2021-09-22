//
//  FavoritesViewModel.swift
//  FavoritesViewModel
//
//  Created by Andrej Hurynovič on 21.09.21.
//

import SwiftUI
import Combine

class FavoritesViewModel: ObservableObject {
    @Published var groups: [Group] = []
    @Published var employees: [Employee] = []
    
    private var groupCancelable: AnyCancellable?
    private var employeeCancelable: AnyCancellable?
    
    
    
    init(groupPublisher: AnyPublisher<[Group], Never> = GroupStorage.shared.groups.eraseToAnyPublisher(),
         employeePublisher: AnyPublisher<[Employee], Never> = EmployeeStorage.shared.employees.eraseToAnyPublisher()) {
        groupCancelable = groupPublisher.sink { groups in
            self.groups = groups.filter({$0.favorite == true})
        }
        employeeCancelable = employeePublisher.sink { employees in
            self.employees = employees.filter({$0.favorite == true})
        }
    }
    
    func removeFromFavorites(_ group: Group? = nil) {
        group?.favorite = false
        GroupStorage.shared.save()
    }
}
