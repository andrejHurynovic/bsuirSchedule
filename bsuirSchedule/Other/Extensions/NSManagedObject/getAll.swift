//
//  getAll.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 1.05.23.
//

import CoreData

extension NSManagedObject {
    static func getAll<Value>(from context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) -> [Value] {
        return try! context.fetch(self.fetchRequest()) as! [Value]
    }
}
