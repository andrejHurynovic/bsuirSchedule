//
//  SequenceSections.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 7.04.23.
//

import Foundation

extension Sequence {
    func sectioned<ObjectType: Hashable>(by keyPath: KeyPath<Element, ObjectType>) -> [ObjectType : [Self.Element]] {
        let dictionary = Dictionary(grouping: self) { $0[keyPath: keyPath] }
        return dictionary
    }
}
