//
//  toolbarCircle.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 7.06.23.
//

import SwiftUI

struct ToolbarCircleModifier: ViewModifier {
    func body(content: Content) -> some View {
        Circle()
            .fill(.tertiary)
            .padding(-4)
            .frame(width: 22, height: 22)
            .overlay(
            content
                .font(.footnote)
            )

    }
    
}

extension View {
    func toolbarCircle() -> some View {
        modifier(ToolbarCircleModifier())
    }
}
