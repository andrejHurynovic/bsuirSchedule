//
//  DegreeExtensions.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 10.05.23.
//

import Foundation

extension Degree: Identifiable {  }

extension Degree {
    var formattedName: String {
        name ?? abbreviation
    }
}
