//
//  CompoundSchedulePickerViewModel.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 14.06.23.
//

import SwiftUI

class CompoundSchedulePickerViewModel: ObservableObject {
    @Published var showCompoundSchedulePickerSheet: Bool = false
    @Published var selectedCompoundScheduled: CompoundScheduled?
}


