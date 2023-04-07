//
//  NSManagedObjectsSection.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 4.04.23.
//

import CoreData

class NSManagedObjectsSection<ObjectType: NSManagedObject> {
    var title: String
    var items: [ObjectType]
    
    init(title: String, items: [ObjectType]) {
        self.title = title
        self.items = items
    }
}
