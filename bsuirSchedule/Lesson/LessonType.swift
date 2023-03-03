//
//  LessonType.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 25.09.22.
//

import Foundation
 
enum LessonType: Int16, CaseIterable {
    case none = 0
    case lecture = 1
    case remoteLecture = 2
    case practice = 3
    case remotePractice = 4
    case laboratory = 5
    case remoteLaboratory = 6
    case consultation = 7
    case exam = 8
    case candidateText = 9
    
    init(from string: String?) {
        switch (string) {
        case "ЛК":
            self = .lecture
        case "УЛк":
            self = .remoteLecture
        case "ПЗ":
            self = .practice
        case "УПз":
            self = .remotePractice
        case "ЛР":
            self = .laboratory
        case "УЛР":
            self = .remoteLaboratory
        case "Экзамен":
            self = .exam
        case "Консультация":
            self = .consultation
        case "Кандидатский зачет":
            self = .candidateText
        default:
            self = .none
            break
        }
    }
    
    var description: String {
        switch self {
        case .none:
            return "Без типа"
        case .lecture:
            return "Лекция"
        case .remoteLecture:
            return "Удалённая лекция"
        case .practice:
            return "Практическое занятие"
        case .remotePractice:
            return "Удалённое практическое занятие"
        case .laboratory:
            return "Лабораторная работа"
        case .remoteLaboratory:
            return "Удалённая лабораторная работа"
        case .consultation:
            return "Консультация"
        case .exam:
            return "Экзамен"
        case .candidateText:
            return "Кандидатский зачёт"
        }
    }
    
    var abbreviation: String {
        switch self {
        case .none:
            return "Без типа"
        case .lecture:
            return "ЛК"
        case .remoteLecture:
            return "УЛК"
        case .practice:
            return "ПЗ"
        case .remotePractice:
            return "УПЗ"
        case .laboratory:
            return "ЛР"
        case .remoteLaboratory:
            return "УЛР"
        case .consultation:
            return "Конс"
        case .exam:
            return "Экз"
        case .candidateText:
            return "КЗ"
        }
    }
}

extension Lesson {
    var lessonType: LessonType {
        get {
            return LessonType(rawValue: self.lessonTypeValue)!
        }
        set {
            self.lessonTypeValue = newValue.rawValue
        }
    }
}
