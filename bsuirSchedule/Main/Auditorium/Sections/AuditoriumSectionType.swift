//
//  AuditoriumSectionType.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 4.04.23.
//

enum AuditoriumSectionType: SectionType {
    case building
    case buildingAndFloor
    case department
    
    var description: String {
        switch self {
            case .building:
                return "Корпус"
            case .buildingAndFloor:
                return "Корпус и этаж"
            case .department:
                return "Подразделение"
        }
    }
}
