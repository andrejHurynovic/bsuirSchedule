//
//  LessonsSectionRepresentationMode.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 21.10.22.
//

enum LessonsSectionRepresentationMode: CaseIterable {
    case dateBased
    case weekBased
    
    var description: String {
        switch self {
        case .dateBased:
            return "датам"
        case .weekBased:
            return "неделям"
        }
    }
}
