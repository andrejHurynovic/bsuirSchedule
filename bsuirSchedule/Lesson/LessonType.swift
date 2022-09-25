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
    
    func description() -> String {
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
    func getLessonTypeAbbreviation() -> String {
        switch self.lessonType {
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
