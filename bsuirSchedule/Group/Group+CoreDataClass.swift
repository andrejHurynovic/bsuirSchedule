//
//  Group+CoreDataClass.swift
//  Group
//
//  Created by Andrej Hurynovič on 6.09.21.
//
//

import Foundation
import CoreData

@objc(Group)
public class Group: NSManagedObject {
    required convenience init(_ groupModel: GroupModel) {
        let context = PersistenceController.shared.container.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Group", in: context)
        self.init(entity: entity!, insertInto: context)
        
        self.id = groupModel.id
        self.course = groupModel.course
        self.facultyID = groupModel.facultyID
        self.educationStart = groupModel.educationStart
        self.educationEnd = groupModel.educationEnd
        self.examsStart = groupModel.examsStart
        self.examsEnd = groupModel.examsEnd
        
        //addToLessons(NSSet(array: groupModel.lessons))
    }
}
