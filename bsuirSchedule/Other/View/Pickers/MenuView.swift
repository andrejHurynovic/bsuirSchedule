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
    
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        Menu {
            content()
        } label: {
            Image(systemName: "line.3.horizontal.decrease")
                .foregroundColor(satisfyDefaultRules ? .accentColor : .primary)
                .toolbarCircle(shapeStyle: satisfyDefaultRules ? .tertiary : .primary)
        }
        
    }
}

class MenuView_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: 16) {
            MenuView(defaultRules: [true]) { }
            MenuView(defaultRules: [false]) { }
        }
    }
}
