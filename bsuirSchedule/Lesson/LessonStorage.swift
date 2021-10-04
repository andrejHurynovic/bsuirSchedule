//
//  LessonStorage.swift
//  LessonStorage
//
//  Created by Andrej Hurynovič on 14.09.21.
//

import Foundation
import Combine
import CoreData

class LessonStorage: NSObject, ObservableObject {
    var lessons = CurrentValueSubject<[Lesson], Never>([])
    private let lessonFetchController: NSFetchedResultsController<Lesson>
    
    static let shared: LessonStorage = LessonStorage()
    
    private override init() {
        lessonFetchController = NSFetchedResultsController(fetchRequest: Lesson.fetchRequest(),
                                                          managedObjectContext: PersistenceController.shared.container.viewContext,
                                                          sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        
        lessonFetchController.delegate = self
        do {
            try lessonFetchController.performFetch()
            lessons.value = lessonFetchController.fetchedObjects ?? []
        } catch {
            
        }
    }
    
    func save() {
        try! PersistenceController.shared.container.viewContext.save()
    }
    
    func delete(_ lesson: Lesson) {
        PersistenceController.shared.container.viewContext.delete(lesson)
        save()
    }
    
    func delete(_ lessons: [Lesson]) {
        lessons.forEach { lesson in
            PersistenceController.shared.container.viewContext.delete(lesson)
        }
        save()
    }
    
    func deleteAll() {
        lessons.value.forEach { lesson in
            PersistenceController.shared.container.viewContext.delete(lesson)
        }
        save()
    }
}

extension LessonStorage: NSFetchedResultsControllerDelegate {
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let lessons = controller.fetchedObjects as? [Lesson] else {return}
        
        self.lessons.value = lessons
    }
}
