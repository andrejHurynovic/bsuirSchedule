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
    @Published var classrooms: [Classroom] = []
    
    private var groupCancelable: AnyCancellable?
    private var employeeCancelable: AnyCancellable?
    private var classroomCancelable: AnyCancellable?
    
    
    
    init(groupPublisher: AnyPublisher<[Group], Never> = GroupStorage.shared.values.eraseToAnyPublisher(),
         employeePublisher: AnyPublisher<[Employee], Never> = EmployeeStorage.shared.values.eraseToAnyPublisher(),
         classroomPublisher: AnyPublisher<[Classroom], Never> = ClassroomStorage.shared.values.eraseToAnyPublisher()) {
        groupCancelable = groupPublisher.sink { groups in
            self.groups = groups.filter({$0.favorite})
        }
        employeeCancelable = employeePublisher.sink { employees in
            self.employees = employees.filter({$0.favorite})
        }
        classroomCancelable = classroomPublisher.sink(receiveValue: { classrooms in
            self.classrooms = classrooms.filter {$0.favorite}
        })
    }
    
    func removeFromFavorites(_ element: Lessonable) {
        element.favorite = false
        try! PersistenceController.shared.container.viewContext.save()
    }
}
