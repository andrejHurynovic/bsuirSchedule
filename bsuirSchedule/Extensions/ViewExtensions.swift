//
//  ViewExtensions.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 19.10.22.
//

import SwiftUI

extension View {
    
    func onLoad(perform action: (() -> Void)? = nil) -> some View {
        modifier(ViewDidLoadModifier(perform: action))
    }
    
}


struct mainBackgroundViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}

extension View {
    func primaryMaterial() -> Material {
        .thinMaterial
    }
}

extension View {
    func primaryBackground() -> some View {
        modifier(mainBackgroundViewModifier())
    }
}
