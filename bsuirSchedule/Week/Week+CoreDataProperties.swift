//
//  Week+CoreDataProperties.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 30.05.22.
//
//

import Foundation
import CoreData


extension Week {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Week> {
        return NSFetchRequest<Week>(entityName: "Week")
    }

    @NSManaged public var updateDate: Date?
    @NSManaged public var updatedWeek: Int16
    
}

extension Week : Identifiable {

}
