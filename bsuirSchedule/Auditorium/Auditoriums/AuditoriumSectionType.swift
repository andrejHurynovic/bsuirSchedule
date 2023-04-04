//
//  AuditoriumSectionType.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 4.04.23.
//

enum AuditoriumSectionType: CaseIterable {
    case building
    case buildingAndFloor
    case department
    
    var description: String {
        switch self {
            case .building:
                return "Здание"
            case .buildingAndFloor:
                return "Здание и этаж"
            case .department:
                return "Подразделение"
        }
    }
}
