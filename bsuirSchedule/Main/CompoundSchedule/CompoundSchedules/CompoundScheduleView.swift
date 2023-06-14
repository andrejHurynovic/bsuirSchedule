//
//  CompoundScheduleView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 14.06.23.
//

import SwiftUI

struct CompoundScheduleView: View {
    @ObservedObject var compoundSchedule: CompoundSchedule
    
    var body: some View {
        SquareTextView(title: compoundSchedule.title,
                       secondSubtitle: "Всего: \(compoundSchedule.allScheduled.count)")
    }
}

struct CompoundScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        if let compoundSchedule : CompoundSchedule = CompoundSchedule.getAll().randomElement() {
            CompoundScheduleView(compoundSchedule: compoundSchedule)
        }
    }
}
