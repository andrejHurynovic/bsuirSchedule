//
//  GroupsSections.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 11.04.23.
//

import CoreData

extension Sequence where Element == Group {
    func sections(_ type: GroupSectionType) -> [NSManagedObjectsSection<Group>] {
        switch type {
            case .specialityAbbreviation:
                return specialitySections(useSpecialityName: false)
            case .specialityName:
                return specialitySections(useSpecialityName: true)
            case .faculty:
                return facultySections()
            case .flow:
                return flowSections()
        }
    }
    
    private func specialitySections(useSpecialityName: Bool = false) -> [NSManagedObjectsSection<Group>] {
        self.sectioned(by: \.speciality)
            .sorted { $0.key?.formattedID() ?? "" < $1.key?.formattedID() ?? "" }
            .map { NSManagedObjectsSection(title: $0.key?.formattedDescription(useSpecialityName: useSpecialityName) ?? "Без специальности",
                                           id: $0.key?.objectID.description ?? "",
                                           items: $0.value) }
    }
    
    private func facultySections() -> [NSManagedObjectsSection<Group>] {
        self.sectioned(by: \.speciality?.faculty)
            .sorted { $0.key?.abbreviation ?? "" < $1.key?.abbreviation ?? "" }
            .map { NSManagedObjectsSection(title: $0.key?.abbreviation ?? "Без факультета",
                                           items: $0.value) }
    }
    
    private func flowSections() -> [NSManagedObjectsSection<Group>] {
        Dictionary(grouping: self, by: { String($0.name.prefix(4)) })
            .sorted { $0.key < $1.key }
            .map { NSManagedObjectsSection(title: $0.key ,
                                           items: $0.value)}
    }
    
}

