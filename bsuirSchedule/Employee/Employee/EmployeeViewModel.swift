//
//  EmployeeViewModel.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 16.09.22.
//

import SwiftUI

class EmployeeViewModel: ObservableObject {
    @Published var lastUpdateDate: Date? = nil
    
    func fetchLastUpdateDate(employee: Employee) async {
        guard let urlID = employee.urlID,
              let data = try? await URLSession.shared.data(from: FetchDataType.employeeUpdateDate.rawValue + urlID) else {
            return
        }
        
        if let lastUpdateDate = try? JSONDecoder().decode(LastUpdateDate.self, from: data) {
            await MainActor.run {
                withAnimation {
                    self.lastUpdateDate = lastUpdateDate.date
                }
            }
            if let employeeUpdateDate = employee.lessonsUpdateDate,
               employeeUpdateDate < lastUpdateDate.date {
                let _ = await employee.update()
            }
        }
    }
    
}
