//
//  HeaderView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 12.04.23.
//

import SwiftUI

struct HeaderView: View {
    var title: String
    var withArrow: Bool
    
    init(_ title: String, withArrow: Bool = false ) {
        self.title = title
        self.withArrow = withArrow
    }
    
    var body: some View {
        HStack {
            Text(title)
                .fontWeight(.heavy)
                .foregroundColor(.primary)
            if withArrow {
                Text(Image(systemName: "chevron.right"))
                    .foregroundColor(.gray)
            }
        }
        .font(.title2)
        .padding(.top)
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HeaderView("ВМСиС", withArrow: false)
            HeaderView("ВМСиС", withArrow: true)
        }
    }
}
