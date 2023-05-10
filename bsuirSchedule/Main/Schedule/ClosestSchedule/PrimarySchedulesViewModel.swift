//
//  PrimarySchedulesViewModel.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 10.05.23.
//

import SwiftUI

class PrimarySchedulesViewModel: ObservableObject {
    @AppStorage("primaryGroup") var primaryGroup: String?
    @AppStorage("primaryGroupSubgroup") var primaryGroupSubgroup: Int?
    @AppStorage("primaryEmployee") var primaryEmployee: Int?
    @AppStorage("primaryAuditorium") var primaryAuditorium: String?
}
