//
//  GroupSection.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 7.10.22.
//

import Foundation

struct GroupSection: Hashable {
    var title: String
    var groups: [Group]
}

enum GroupSortingType: Equatable, CaseIterable {
    case number
    case speciality
}

extension Array where Element == Group {
    ///Returns array of groups filtered by faculty and educationType if they are presented
    func filtered(by faculty: Faculty?, _ educationType: EducationType?) -> [Group] {
        var groups = self
        if let faculty = faculty {
            groups.removeAll { $0.speciality.faculty != faculty }
        }
        if let educationType = educationType {
            groups.removeAll { $0.speciality.educationType != educationType }
        }
        return groups
    }
    
    ///Returns array of group sections sorted by speciality or number
    func sections(by sortingType: GroupSortingType) -> [GroupSection] {
        var sections: [GroupSection] = []
        
        switch sortingType {
        case .number:
            let prefixes = Set((self.map { $0.id.prefix(3) }))
            for prefix in prefixes.sorted() {
                sections.append(GroupSection(
                    title: String(prefix),
                    groups: self.filter({ $0.id.prefix(3) == prefix })))
            }
        case .speciality:
            let specialities = Set((self.compactMap { $0.speciality }))
            for speciality in specialities.sorted(by: { $0.name < $1.name }) {
                sections.append(GroupSection(
                    title: speciality.description,
                    groups: self.filter({ $0.speciality == speciality })))
            }
 
        }
        return sections
    }
}
