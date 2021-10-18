//
//  Classroom+CoreDataClass.swift
//  Classroom
//
//  Created by Andrej Hurynovič on 25.09.21.
//
//

import Foundation
import CoreData

@objc(Classroom)
public class Classroom: NSManagedObject {
    
    required convenience init(_ classroom: ClassroomModel) {
        let context = PersistenceController.shared.container.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Classroom", in: context)
        self.init(entity: entity!, insertInto: context)
        
        self.name = classroom.name
        self.building = classroom.building
        self.typeValue = classroom.typeValue
        
        self.departmentName = classroom.departmentName
        self.departmentAbbreviation = classroom.departmentAbbreviation
    }
    
    func getClassroomTypeDescription() -> String {
        switch self.typeValue {
        case 1:
            return "ЛК"
        case 2:
            return "ПЗ"
        case 3:
            return "ЛР"
        case 4:
            return "КК"
        case 5:
            return "ВП"
        case 6:
            return "РК"
        case 7:
            return "НЛ"
        default:
            return ""
        }
    }
    
    func groups() -> [Group] {
        var groups = Set<Group>()
        
        if let lessons = self.lessons?.allObjects as? [Lesson] {
            lessons.forEach { lesson in
                if let lessonsGroups = lesson.groups?.allObjects as? [Group] {
                    lessonsGroups.forEach { group in
                        groups.insert(group)
                    }
                }
            }
        }
        return groups.sorted{$0.id! < $1.id!}
    }
    
    func educationStart() -> Date {
        var dates = Set<Date>()
        groups().forEach{dates.insert($0.educationStart!)}
        
        return dates.sorted().first!
    }
    
    func educationEnd() -> Date {
        var dates = Set<Date>()
        groups().forEach{dates.insert($0.educationEnd!)}
        
        return dates.sorted().last!
    }
}
