//
//  GroupSectionType.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 11.04.23.
//

enum GroupSectionType: SectionType {
    case specialityAbbreviation
    case specialityName
    case faculty
    case flow
    
    var description: String {
        switch self {
            case .specialityAbbreviation:
                return "Специальность сокращённая"
            case .specialityName:
                return "Специальность полная"
            case .faculty:
                return "Факультет"
            case .flow:
                return "Поток"
        }
    }
}
