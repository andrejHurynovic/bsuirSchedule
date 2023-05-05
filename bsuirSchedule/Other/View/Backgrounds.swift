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
#if os(iOS)
            .background(Color(UIColor.systemGroupedBackground))
        
#elseif os(macOS)
            .background(Color(NSColor.underPageBackgroundColor))
        
#endif
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
#if os(iOS)
            .background(Color(uiColor: .secondarySystemGroupedBackground),
                        in: RoundedRectangle(cornerRadius: 16))
        
#elseif os(macOS)
            .background(Color(NSColor.windowBackgroundColor))
        
#endif
        
    }
}

extension View {
    func roundedRectangleBackground() -> some View {
        modifier(roundedRectangleBackgroundViewModifier())
    }
}
