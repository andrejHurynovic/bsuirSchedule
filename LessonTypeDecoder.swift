//
//  LessonTypeDecoder.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 1.05.23.
//
//

import CoreData
import SwiftUI

@objc(LessonType)
public class LessonType: NSManagedObject {
    required public convenience init(id: String, context: NSManagedObjectContext) {
        self.init(entity: LessonType.entity(), insertInto: context)
        
        self.id = id
    }
    
    required public convenience init(id: String,
                                     name: String,
                                     abbreviation: String,
                                     color: Color,
                                     context: NSManagedObjectContext) {
        self.init(entity: LessonType.entity(), insertInto: context)
        
        self.id = id
        self.name = name
        self.abbreviation = abbreviation
        self.color = color
    }
}
