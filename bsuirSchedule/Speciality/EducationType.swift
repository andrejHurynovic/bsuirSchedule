//
//  EducationType.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 13.10.22.
//

enum EducationType: Int16, CaseIterable {
    case unknown = 0
    case fullTime = 1
    case distant = 2
    case remote = 3
    case night = 4
    
    var description: String {
        switch self {
        case .unknown:
            return "неизвестно"
        case .fullTime:
            return "дневная"
        case .distant:
            return "заочная"
        case .remote:
            return "дистанционная"
        case .night:
            return "вечерняя"
        }
    }
}
