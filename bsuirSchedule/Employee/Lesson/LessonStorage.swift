//
//  LessonStorage.swift
//  LessonStorage
//
//  Created by Andrej Hurynovič on 14.09.21.
//

import Foundation

class LessonStorage: Storage<Lesson> {
    static let shared = LessonStorage(sortDescriptors: [NSSortDescriptor(keyPath: \Lesson.subgroup, ascending: true)])
    
    static func groups(lessons: NSSet?) -> [Group] {
        var groups = Set<Group>()
        
        if let lessons = lessons?.allObjects as? [Lesson] {
            lessons.forEach { lesson in
                if let lessonsGroups = lesson.groups?.allObjects as? [Group] {
                    lessonsGroups.forEach { group in
                        groups.insert(group)
                    }
                }
            }
        }
        return groups.sorted{$0.id! < $1.id!}
    }
}
