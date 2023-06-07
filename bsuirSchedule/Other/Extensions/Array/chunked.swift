//
//  chunked.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 7.06.23.
//

import Foundation

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
