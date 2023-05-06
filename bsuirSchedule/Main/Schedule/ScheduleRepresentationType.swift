//
//  ScheduleRepresentationType.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 6.05.23.
//

enum ScheduleRepresentationType: SectionType {
    case page
    case scroll
    
    var description: String {
        switch self {
            case .page:
                return "страницы"
            case .scroll:
                return "список"
        }
    }
}
