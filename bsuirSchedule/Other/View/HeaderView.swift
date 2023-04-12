//
//  HeaderView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 12.04.23.
//

import SwiftUI

struct HeaderView: View {
    var title: String
    
    init(_ title: String) {
        self.title = title
    }
    
    var body: some View {
        Text(title)
            .font(.title2)
            .fontWeight(.heavy)
            .foregroundColor(.primary)
            .padding(.top)
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView("ВМСиС")
    }
}
