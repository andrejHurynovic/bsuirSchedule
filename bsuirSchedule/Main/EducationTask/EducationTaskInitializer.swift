//
//  EducationTaskInitializer.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 11.05.23.
//

import CoreData

@objc(EducationTask)
public class EducationTask: NSManagedObject {
    convenience init(subject: String, context: NSManagedObjectContext) {
        self.init(entity: EducationTask.entity(), insertInto: context)
        
        self.subject = subject
        self.creation = .now
    }
}

