//
//  EducationDegree.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 8.04.23.
//

enum EducationDegree: Int16, CaseIterable {
    case bachelor = 1
    case master = 2
    
    var description: String {
        switch self {
            case .bachelor:
                return "Бакалавриат"
            case .master:
                return "Магистратура"
        }
    }
}

extension Group {
    var educationDegree: EducationDegree? {
        EducationDegree(rawValue: self.educationDegreeValue)
    }
}
