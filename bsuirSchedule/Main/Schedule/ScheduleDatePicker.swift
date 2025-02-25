//
//  ScheduleDatePicker.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 7.05.23.
//

import SwiftUI

struct ScheduleDatePicker: View {
    @Binding var showDatePicker: Bool
    @Binding var selectedDate: Date
    var educationRange: ClosedRange<Date>?
    
    var body: some View {
        if let educationRange = educationRange {
            DatePicker("Выбор даты:",
                       selection: $selectedDate,
                       in: educationRange,
                       displayedComponents: .date)
            
            .datePickerStyle(.graphical)
            .padding()
            .presentationDetents([.medium])
        }
        Button {
            showDatePicker = false
        } label: {
            Text("Готово")
                .bold()
                .foregroundColor(.white)
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .background(RoundedRectangle(cornerRadius: 16)
                    .fill(Color.accentColor)
                    .shadow(radius: 8)
                )
                
        }
        .padding([.horizontal, .bottom])
    }
    
}
