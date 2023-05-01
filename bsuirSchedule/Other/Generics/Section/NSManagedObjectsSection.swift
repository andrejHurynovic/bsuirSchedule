//
//  NSManagedObjectsSection.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 4.04.23.
//

import CoreData

class NSManagedObjectsSection<ObjectType: NSManagedObject> {
    var title: String
    var id: String?
    @Published var items: [ObjectType]
    
    init(title: String, id: String? = nil, items: [ObjectType]) {
        self.title = title
        self.id = id ?? title
        self.items = items
    }
}
