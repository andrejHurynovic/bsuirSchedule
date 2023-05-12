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
    var cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
#if os(iOS)
            .background(Color(uiColor: .secondarySystemGroupedBackground),
                        in: RoundedRectangle(cornerRadius: 16))
        
#elseif os(macOS)
            .background(Color(NSColor.windowBackgroundColor),
                        in: RoundedRectangle(cornerRadius: 16))
        
#endif
        
    }
}

extension View {
    func roundedRectangleBackground(cornerRadius: CGFloat = 16.0) -> some View {
        modifier(roundedRectangleBackgroundViewModifier(cornerRadius: cornerRadius))
    }
}
