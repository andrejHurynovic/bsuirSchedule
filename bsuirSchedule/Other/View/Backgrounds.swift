//
//  Backgrounds.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 13.04.23.
//

import SwiftUI

//MARK: - roundedRectangleBackground

struct baseBackgroundViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color(UIColor.systemGroupedBackground))
    }
}

extension View {
    func baseBackground() -> some View {
        modifier(baseBackgroundViewModifier())
    }
}


//MARK: - baseBackground

struct roundedRectangleBackgroundViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color(uiColor: .secondarySystemGroupedBackground),
                        in: RoundedRectangle(cornerRadius: 16))
    }
}

extension View {
    func roundedRectangleBackground() -> some View {
        modifier(roundedRectangleBackgroundViewModifier())
    }
}
