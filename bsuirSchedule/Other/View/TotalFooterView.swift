//
//  TotalFooterView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 4.04.23.
//

import SwiftUI

struct TotalFooterView: View {
    var text: String
    var count: Int
    
    var body: some View {
        if count > 0 {
            HStack {
                Text("Всего \(text): \(count)".uppercased())
                    .font(.footnote)
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(.top, -16)
            .padding([.horizontal, .bottom])
        }
    }
}

struct TotalFooterView_Previews: PreviewProvider {
    static var previews: some View {
        TotalFooterView(text: "групп",
                        count: 1402)
    }
}
