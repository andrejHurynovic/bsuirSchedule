//
//  HometaskInitializer.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 11.05.23.
//

import CoreData

@objc(Hometask)
public class EducationTask: NSManagedObject {
    convenience init(subject: String, note: String, photosData: Data?, deadline: Date?) {
        let context = PersistenceController.shared.container.newBackgroundContext()
        self.init(entity: EducationTask.entity(), insertInto: context)
        
        self.subject = subject
        self.note = note
        self.photosData = photosData
        self.creation = .now
        self.deadline = deadline
    }
}

