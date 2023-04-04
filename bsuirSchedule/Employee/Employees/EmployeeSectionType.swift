//
//  EmployeeSectionType.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 4.04.23.
//

enum EmployeeSectionType: CaseIterable {
    case firstLetter
    case department
    case rank
    case degree
    
    var description: String {
        switch self {
            case .firstLetter:
                return "Алфавит"
            case .department:
                return "Подразделение"
            case .rank:
                return "Ранг"
            case .degree:
                return "Степень"
        }
    }
}
