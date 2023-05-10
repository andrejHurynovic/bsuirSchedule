//
//  SettingsViewModel.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 21.10.22.
//

import SwiftUI

class SettingsViewModel: ObservableObject {
    @AppStorage("tintColor") var tintColor: Color = Color.blue
}
