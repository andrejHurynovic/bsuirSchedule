//
//  LessonsSectionView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 19.10.22.
//

import SwiftUI

struct LessonsGroupView: View {
    
    var lessons: [Lesson]
    var showEmployees: Bool
    var showGroups: Bool
    var showWeeks: Bool
    var sectionID: String
    
    var body: some View {
        ForEach(lessons, id: \.self) { lesson in
            LessonView(lesson: lesson,
                       showEmployee: showEmployees,
                       showGroups: showGroups,
                       showWeeks: showWeeks
            )
            .id(lesson.id(sectionID: sectionID))
        }
    }
    
}
