//
//  EmployeeViewModel.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 16.09.22.
//

import Foundation
import Combine

class EmployeeViewModel: ObservableObject {
    
    @Published var employee: Employee
    
    @Published var lastUpdateDate: Date? = nil
    var cancellable: AnyCancellable? = nil
    
    @Published var imagesViewModel = ImagesViewModel()
    
    @Published var selectedFaculty: Faculty? = nil
    @Published var selectedEducationType: EducationType? = nil
    @Published var sortedBy: GroupSortingType = .speciality
    
    init(_ employee: Employee) {
        self.employee = employee
        
        getUpdateDate()
    }
    
    func getUpdateDate() {
        cancellable = FetchManager.shared.fetch(dataType: .employeeUpdateDate, argument: employee.urlID) { [weak self] (date: LastUpdateDate) -> () in
            self?.lastUpdateDate = date.lastUpdateDate
            
            if let employeeUpdateDate = self?.employee.updateDate, employeeUpdateDate < date.lastUpdateDate{
                self?.update()
            }
        }
    }
    
    func update() {
        EmployeeStorage.shared.update(employee)
    }
    
}
