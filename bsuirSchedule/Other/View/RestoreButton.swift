//
//  RestoreButton.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 8.06.23.
//

import SwiftUI

struct RestoreButton: View {
    var action: () -> ()
    
    @State private var showAlert: Bool = false
    
    var body: some View {
        Button {
            showAlert = true
        } label: {
            Label("Сбросить", systemImage: "arrow.uturn.left")
                .foregroundColor(.red)
        }
        .alert("Вы уверены?", isPresented: $showAlert) {
            Button ("Сбросить", role: .destructive) {
                action()
            }
            Button ("Отмена", role: .cancel) {}
        }
    }
}

struct RestoreButton_Previews: PreviewProvider {
    static var previews: some View {
        RestoreButton(action: { })
    }
}
