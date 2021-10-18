//
//  LessonStorage.swift
//  LessonStorage
//
//  Created by Andrej Hurynovič on 14.09.21.
//

class LessonStorage: Storage<Lesson> {
    static let shared = LessonStorage(sortDescriptors: [])
}
