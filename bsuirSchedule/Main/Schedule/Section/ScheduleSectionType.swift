//
//  ScheduleSectionType.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 13.04.23.
//

enum ScheduleSectionType: SectionType {
    case date
    case week
    
    var description: String {
        switch self {
            case .date:
                return "даты"
            case .week:
                return "недели"
        }
    }
}
