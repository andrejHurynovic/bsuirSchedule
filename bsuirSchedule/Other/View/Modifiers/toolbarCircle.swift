//
//  toolbarCircle.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 7.06.23.
//

import SwiftUI

struct ToolbarCircleModifier<ShapeType: ShapeStyle>: ViewModifier {
    var shapeStyle: ShapeType
    
    func body(content: Content) -> some View {
        Circle()
            .fill(shapeStyle)
            .padding(-4)
            .frame(width: 22, height: 22)
            .overlay(
            content
                .font(.footnote)
            )

    }
    
}

extension View {
    func toolbarCircle<ShapeType: ShapeStyle>(shapeStyle: ShapeType = .tertiary) -> some View {
        modifier(ToolbarCircleModifier(shapeStyle: shapeStyle))
    }
}

class ToolbarCircleModifier_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(defaultRules: [false]) { }
    }
}
