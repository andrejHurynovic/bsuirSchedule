//
//  FormView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 7.04.23.
//

import SwiftUI

struct FormView: View  {
    var title: String
    var text: String
    
    init(_ name: String, _ parameter: String) {
        self.title = name
        self.text = parameter
    }
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.primary)
            Spacer()
            Text(text)
                .foregroundColor(.secondary)
        }
    }
}

struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        FormView("Подразделение:", "ЭВМ")
    }
}
