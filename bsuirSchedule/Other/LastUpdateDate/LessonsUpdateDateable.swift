//
//  LessonsUpdateDateable.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 09.04.23.
//

import CoreData

protocol LessonsUpdateDateable: NSManagedObject {
    associatedtype AssociatedType
    
    var lessonsUpdateDate: Date? { get set }
    
    func fetchLastUpdateDate() async -> Date?
    func update() async -> AssociatedType
}
