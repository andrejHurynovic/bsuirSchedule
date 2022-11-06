//
//  LessonsSectionView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 19.10.22.
//

import SwiftUI

struct LessonsSectionView: View {
    
    var section: LessonsSection
    var showEmployees: Bool
    var showGroups: Bool
    
    @Binding var showDatePicker: Bool
    
    var body: some View {
        Section {
            LessonsGroupView(lessons: section.lessons,
                             showEmployees: showEmployees,
                             showGroups: showGroups,
                             sectionID: section.id)
        } header: {
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.9)) {
                    showDatePicker.toggle()
                }
            } label: {
                VStack(alignment: .leading) {
                    standardizedHeader(title: section.title)
                }
            }
        }
        
    }
    
}

