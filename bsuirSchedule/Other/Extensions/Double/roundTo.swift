//
//  roundTo.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 25.04.23.
//

import Foundation

extension Double {
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
