//
//  ClassroomType.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 29.06.22.
//

enum ClassroomType: Int16, CaseIterable {
    case unknown = 0
    case lecture = 1
    case practice = 2
    case laboratory = 3
    case computerClass = 4
    case maintenance = 5
    case office = 6
    case scienceLaboratory = 7

    var abbreviation: String {
        switch self {
        case .unknown:
            return "-"
        case .lecture:
            return "ЛК"
        case .practice:
            return "ПЗ"
        case .laboratory:
            return "ЛР"
        case .computerClass:
            return "КК"
        case .maintenance:
            return "ВП"
        case .office:
            return "РК"
        case .scienceLaboratory:
            return "НЛ"
        }
    }
    
    
}
