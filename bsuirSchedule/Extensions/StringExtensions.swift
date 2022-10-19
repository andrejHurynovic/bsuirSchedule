//
//  StringExtensions.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 19.10.22.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
