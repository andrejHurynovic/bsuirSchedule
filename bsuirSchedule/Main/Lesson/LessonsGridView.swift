//
//  LessonsGridView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 7.05.23.
//

import SwiftUI

struct LessonsGridView<Content: View>: View {
    var content: () -> Content
    
    var body: some View {
        LazyVGrid(columns: [LessonView.gridItem], alignment: .leading, spacing: 8, pinnedViews: []) {
            content()
        }
    }
}

