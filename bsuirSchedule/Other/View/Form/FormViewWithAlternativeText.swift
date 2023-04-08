//
//  FormViewWithAlternativeText.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 7.04.23.
//

import SwiftUI

struct FormViewWithAlternativeText: View {
    var title: String
    var text: String?
    var alternativeText: String?
    
    @State var showAlternativeText = false
    
    init(_ name: String, _ parameter: String?, _ alternativeText: String?) {
        self.title = name
        self.text = parameter
        self.alternativeText = alternativeText
    }
    
    var body: some View {
        if let text = text {
            if let alternativeText = alternativeText {
                Button {
                    withAnimation { showAlternativeText.toggle() }
                } label: {
                    FormView(title, showAlternativeText ? alternativeText : text)
                }
            } else {
                FormView(title, text)
            }
        }
    }
}

struct FormViewWithAlternativeText_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            FormViewWithAlternativeText("Подразделение:",
                                        "ЭВМ",
                                        "Кафедра Электронных вычислительных машин")
            FormViewWithAlternativeText("Подразделение:",
                                        "ЭВМ",
                                        nil)
        }
    }
}
