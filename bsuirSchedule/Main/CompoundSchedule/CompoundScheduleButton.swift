//
//  CompoundScheduleButton.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 14.06.23.
//

import SwiftUI

struct CompoundScheduleButton<ScheduledType: CompoundScheduled>: View {
    @EnvironmentObject var compoundSchedulePickerViewModel: CompoundSchedulePickerViewModel
    @ObservedObject var item: ScheduledType
    
    var body: some View {
        Button {
            withAnimation() {
                compoundSchedulePickerViewModel.selectedCompoundScheduled = item
                compoundSchedulePickerViewModel.showCompoundSchedulePickerSheet = true
            }
        } label: {
            Label("Совмещённое расписание", systemImage: "archivebox")
        }
    }
    
    
}

//struct CompoundScheduleButton_Previews: PreviewProvider {
//    static var previews: some View {
//        CompoundScheduleButton()
//    }
//}
