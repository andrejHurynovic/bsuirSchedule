//
//  NSManagedObject.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 19.03.23.
//

import CoreData

extension NSManagedObject {
    static func getAll<T:NSManagedObject>(context: NSManagedObjectContext) async -> [T] {
        return try! context.fetch(T.fetchRequest()) as! [T]
    }
}
