//
//  SquareView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 11.05.23.
//

import SwiftUI

struct SquareView<Content: View>: View {
    
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        content()
        .padding()
        .roundedRectangleBackground()
        .aspectRatio(1.0, contentMode: .fit)

    }
}
