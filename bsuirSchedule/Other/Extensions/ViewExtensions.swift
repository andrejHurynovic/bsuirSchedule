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
