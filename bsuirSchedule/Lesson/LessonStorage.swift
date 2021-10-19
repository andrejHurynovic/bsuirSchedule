//
//  LessonStorage.swift
//  LessonStorage
//
//  Created by Andrej Hurynovič on 14.09.21.
//

import Foundation

class LessonStorage: Storage<Lesson> {
    static let shared = LessonStorage(sortDescriptors: [NSSortDescriptor(keyPath: \Lesson.subgroup, ascending: true)])
}
