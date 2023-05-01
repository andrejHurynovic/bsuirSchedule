//
//  SettingsViewModel.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 21.10.22.
//

import SwiftUI

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

class SettingsViewModel: ObservableObject {
    
    @AppStorage("primaryType") var primaryTypeValue: Int = 0
    
    var primaryType: PrimaryType {
        PrimaryType(rawValue: primaryTypeValue)!
    }
    
    @AppStorage("primaryGroup") var primaryGroup: String?
    @AppStorage("primaryGroupSubgroup") var primaryGroupSubgroup: Int?
    @AppStorage("primaryEmployee") var primaryEmployee: Int?
    @AppStorage("primaryAuditorium") var primaryAuditorium: String?
    
}
