//
//  AuditoriumDecodingError.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 1.05.23.
//

import Foundation

enum AuditoriumDecodingError: Error {
    case incorrectName(name: String)
    case nonEducationalBuilding
}
