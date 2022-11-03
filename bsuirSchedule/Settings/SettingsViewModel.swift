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
    case classroom = 2
    
    var description: String {
        switch self {
        case .group:
            return "Группа"
        case .employee:
            return "Преподаватель"
        case .classroom:
            return "Кабинет"
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
    @AppStorage("primaryClassroom") var primaryClassroom: String?
    
    @AppStorage("mainColor") var mainColor = Color.accentColor
    @AppStorage("lectureColor") var lectureColor: Color = Color(red: -4.06846e-06, green: 0.631373, blue: 0.847059)
    @AppStorage("practiceColor") var practiceColor = Color(red: 1, green: 0.415686, blue: 9.62615e-08)
    @AppStorage("laboratoryColor") var laboratoryColor = Color(red: 0.745098, green: 0.219608, blue: 0.952942)
    @AppStorage("consultationColor") var consultationColor = Color(red: 0.156956, green: 0.374282, blue: 0.959858)
    @AppStorage("examColor") var examColor = Color(red: 0.280348, green: 0.14247, blue: 0.671006)
    
    @Published var showingRestoreDefaultColorsAlert = false
    
    
    func restoreDefaultColors() {
        mainColor = Color.accentColor
        lectureColor = Color(red: -4.06846e-06, green: 0.631373, blue: 0.847059)
        practiceColor = Color(red: 1, green: 0.415686, blue: 9.62615e-08)
        laboratoryColor = Color(red: 0.745098, green: 0.219608, blue: 0.952942)
        consultationColor = Color(red: 0.156956, green: 0.374282, blue: 0.959858)
        examColor = Color(red: 0.280348, green: 0.14247, blue: 0.671006)
    }
    
}
