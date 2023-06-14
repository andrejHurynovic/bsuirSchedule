//
//  AuditoriumExtensions.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 30.04.23.
//

import CoreData

extension Auditorium: Identifiable {}
extension Auditorium: Favored {}

extension Auditorium: EducationRanged { }

extension Auditorium: Comparable {
    public static func < (lhs: Auditorium, rhs: Auditorium) -> Bool {
        if lhs.building < rhs.building {
            return true
        }
        if lhs.formattedName < rhs.formattedName {
            return true
        }
        return false
    }
}

extension Auditorium: Scheduled {
    var title: String { self.formattedName }
}
extension Auditorium: CompoundScheduled { }

extension Auditorium {
    var groups: [Group]? {
        guard let lessons = lessons?.allObjects as? [Lesson], !lessons.isEmpty else { return nil }
        let groups = lessons.compactMap { $0.groups?.allObjects as? [Group] }.flatMap { $0 }
        return Set(groups).sorted { $0.name < $1.name }
    }
}
