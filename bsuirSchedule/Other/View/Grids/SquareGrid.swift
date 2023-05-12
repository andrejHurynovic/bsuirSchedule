//
//  SquareGrid.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 5.05.23.
//

import SwiftUI

struct SquareGrid<Content: View>: View {
    
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        LazyVGrid(columns: [SquareTextView.gridItem],
                  alignment: .leading,
                  spacing: 8) {
            content()
        }
        
    }
}
