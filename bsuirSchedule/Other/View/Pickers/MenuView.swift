//
//  MenuView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 5.04.23.
//

import SwiftUI

struct MenuView<Content: View>: View {
    var defaultRules: [Bool]
    var satisfyDefaultRules: Bool {
        !defaultRules.contains(false)
    }
    var imageName: String {
        if satisfyDefaultRules {
             return "line.3.horizontal.decrease.circle"
        } else {
             return "line.3.horizontal.decrease.circle.fill"
            
        }
    }
    
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        Menu {
            content()
        } label: {
            Image(systemName: satisfyDefaultRules ? "line.3.horizontal.decrease" : "line.3.horizontal.decrease.fill")
                .toolbarCircle()
        }
        
    }
}
