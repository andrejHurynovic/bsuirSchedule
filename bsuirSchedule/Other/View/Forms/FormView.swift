//
//  FormView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 7.04.23.
//

import SwiftUI

struct FormView: View  {
    var title: String
    var text: String?
    
    init(_ title: String, _ text: String?) {
        self.title = title
        self.text = text
    }
    
    @ViewBuilder var body: some View {
        if let text = text {
            HStack {
                Text(title)
                    .foregroundColor(.primary)
                Spacer()
                Text(text)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        FormView("Подразделение:", "ЭВМ")
    }
}
