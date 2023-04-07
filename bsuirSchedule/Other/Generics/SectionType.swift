//
//  SectionType.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 5.04.23.
//

protocol SectionType: Hashable, CaseIterable where AllCases == Array<Self> {
    var description: String { get }
}
