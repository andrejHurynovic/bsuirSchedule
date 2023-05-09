//
//  LessonsSectionView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 19.10.22.
//

import SwiftUI

struct ScheduleSectionView: View {
    
    @ObservedObject var section: ScheduleSection
    @Binding var showDatePicker: Bool
    
    var body: some View {
        Section {
            ForEach(section.lessons) { lesson in
                LessonView(lesson: lesson,
                           today: section.today
                )
                .id(lesson.id(sectionID: section.id))
            }
        } header: {
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.9)) {
                    showDatePicker.toggle()
                }
            } label: {
                VStack(alignment: .leading) {
                    HeaderView(section.title + section.weekDescription)
                }
            }
        }
        
    }
    
}

