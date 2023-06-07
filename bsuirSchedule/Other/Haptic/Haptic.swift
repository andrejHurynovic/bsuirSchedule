//
//  Haptic.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 7.06.23.
//

import SwiftUI

struct Haptic {
    private static let lightImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    static func impact(_ type: HapticType) {
        switch type {
            case .light:
                Haptic.lightImpactFeedbackGenerator.impactOccurred()
        }
    }
}
