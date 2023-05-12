//
//  EducationTask.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 11.05.23.
//

import CoreData

extension EducationTask {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<EducationTask> {
        let request = NSFetchRequest<EducationTask>(entityName: "Hometask")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \EducationTask.deadline, ascending: true)]
        return request
    }
    @NSManaged public var subject: String
    @NSManaged public var note: String
    @NSManaged public var images: [Data]?
    
    @NSManaged public var creation: Date
    @NSManaged public var deadline: Date?
}
