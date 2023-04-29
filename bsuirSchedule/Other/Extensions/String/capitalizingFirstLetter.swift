//
//  capitalizingFirstLetter.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 19.10.22.
//

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
