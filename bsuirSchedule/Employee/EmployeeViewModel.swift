//
//  EmployeeViewModel.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 16.09.22.
//

import Foundation
import SwiftUI

class EmployeeViewModel: ObservableObject {
    
    @Published var employee: Employee
    
    @Published var lastUpdateDate: Date? = nil
    
    @Published var imagesViewModel = ImagesViewModel()
    
    @Published var selectedFaculty: Faculty? = nil
    @Published var selectedEducationType: EducationType? = nil
    @Published var sortedBy: GroupSortingType = .speciality
    
    init(_ employee: Employee) {
        self.employee = employee
    }
    
    
    
    func update() async {
        let _ = await employee.update()
        let _ = await employee.updatePhoto()
        await MainActor.run {
            try! PersistenceController.shared.container.viewContext.save()
        }
    }
    
    func fetchLastUpdateDate() async {
        guard let data = try? await URLSession.shared.data(from: FetchDataType.employeeUpdateDate.rawValue + String(employee.urlID)) else {
            return
        }
        
        if let date = try? JSONDecoder().decode(LastUpdateDate.self, from: data) {
            await MainActor.run {
                withAnimation {
                    self.lastUpdateDate = date.lastUpdateDate
                }
            }
        }
    }
    
}
