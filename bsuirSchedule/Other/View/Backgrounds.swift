//
//  Backgrounds.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 13.04.23.
//

import SwiftUI

//MARK: - baseRoundedRectangle

extension View {
    func baseRoundedRectangle() -> some View {
        modifier(baseRoundedRectangleViewModifier())
    }
}

struct baseRoundedRectangleViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color(uiColor: .secondarySystemGroupedBackground),
                        in: RoundedRectangle(cornerRadius: 16))
    }
}

//MARK: - baseBackground

extension View {
    func baseBackground() -> some View {
        modifier(baseBackgroundViewModifier())
    }
}

struct baseBackgroundViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color(UIColor.systemGroupedBackground))
    }
}
