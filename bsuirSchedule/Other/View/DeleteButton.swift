//
//  DeleteButton.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 12.05.23.
//

import SwiftUI

struct DeleteButton: View {
    
    var action: () -> ()
    
    var body: some View {
        Button(role: .destructive) {
            action()
        } label: {
            Label("Удалить", systemImage: "trash")
        }
    }
}

struct DeleteButton_Previews: PreviewProvider {
    static var previews: some View {
        DeleteButton(action: { })
    }
}
