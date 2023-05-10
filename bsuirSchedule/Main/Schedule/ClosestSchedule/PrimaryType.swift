//
//  PrimaryType.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 10.05.23.
//

enum PrimaryType: Int, CaseIterable {
    case group = 0
    case employee = 1
    case auditorium = 2
    
    var description: String {
        switch self {
        case .group:
            return "Группа"
        case .employee:
            return "Преподаватель"
        case .auditorium:
            return "Аудитория"
        }
    }
}
