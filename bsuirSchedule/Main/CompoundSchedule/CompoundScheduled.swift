//
//  CompoundScheduled.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 14.06.23.
//

import CoreData

protocol CompoundScheduled: NSManagedObject {
    
    var lessons: NSSet? { get }
    
    func addToCompoundSchedules(_ value: CompoundSchedule)
    func removeFromCompoundSchedules(_ value: CompoundSchedule)
    func addToCompoundSchedules(_ values: NSSet)
    func removeFromCompoundSchedules(_ values: NSSet)
}
