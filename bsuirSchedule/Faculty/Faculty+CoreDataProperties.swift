//
//  Faculty+CoreDataProperties.swift
//  Faculty
//
//  Created by Andrej Hurynovič on 21.09.21.
//
//

import Foundation
import CoreData


extension Faculty {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Faculty> {
        let request = NSFetchRequest<Faculty>(entityName: "Faculty")
        request.sortDescriptors = []
        return request
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var abbreviation: String?
    @NSManaged public var groups: NSSet?

}

// MARK: Generated accessors for groups
extension Faculty {

    @objc(addGroupsObject:)
    @NSManaged public func addToGroups(_ value: Group)

    @objc(removeGroupsObject:)
    @NSManaged public func removeFromGroups(_ value: Group)

    @objc(addGroups:)
    @NSManaged public func addToGroups(_ values: NSSet)

    @objc(removeGroups:)
    @NSManaged public func removeFromGroups(_ values: NSSet)

}

extension Faculty : Identifiable {

}
