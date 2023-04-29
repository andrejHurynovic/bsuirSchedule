//
//  SectionTypePicker.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 5.04.23.
//

import SwiftUI

struct SectionTypePicker<SectionEnum: SectionType>: View {
    @Binding var value: SectionEnum
    
    var body: some View {
        Text("Сортировка:")
        Picker("", selection: $value.animation(.spring())) {
            ForEach(SectionEnum.allCases, id: \.self) { type in
                Text(type.description)
            }
        }
    }
    
}

struct SortingPicker_Previews: PreviewProvider {
    static var previews: some View {
        @State var selectedAuditoriumType = AuditoriumSectionType.building
        SectionTypePicker(value: $selectedAuditoriumType)
    }
}
