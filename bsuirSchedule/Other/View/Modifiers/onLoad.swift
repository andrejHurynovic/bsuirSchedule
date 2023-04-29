//
//  onLoad.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 19.10.22.
//

import SwiftUI


struct OnLoadModifier: ViewModifier {
    @State private var didLoad = false
    
    private let action: (() -> Void)?
    
    init(perform action: (() -> Void)? = nil) {
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content.onAppear {
            if didLoad == false {
                didLoad = true
                action?()
            }
        }
    }
    
}

extension View {
    func onLoad(perform action: (() -> Void)? = nil) -> some View {
        modifier(OnLoadModifier(perform: action))
    }
}
