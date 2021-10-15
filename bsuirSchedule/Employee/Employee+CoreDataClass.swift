//
//  Employee+CoreDataClass.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 4.06.21.
//
//

import Foundation
import CoreData
import UIKit.UIImage

@objc(Employee)
public class Employee: NSManagedObject {
    
    required convenience init(_ employee: EmployeeModel) {
        let context = PersistenceController.shared.container.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Employee", in: context)
        self.init(entity: entity!, insertInto: context)
        
        self.id = employee.id!
        self.urlID = employee.urlID
        self.firstName = employee.firstName
        self.middleName = employee.middleName
        self.lastName = employee.lastName
        
        self.rank = employee.rank
        self.degree = employee.degree
        self.departments = employee.departments
        self.favorite = employee.favorite
        
        self.photoLink = employee.photoLink
    }
    
    func update(_ updatedEmployee: EmployeeModel) {
        
        let existingLessons = (self.lessons?.allObjects as! [Lesson])
        var lessonsToRemove: [Lesson] = []
        
        existingLessons.forEach { oldLesson in
            if updatedEmployee.lessons.contains(where: { newLesson in
                oldLesson.weekDay == newLesson.weekDay &&
                oldLesson.weekNumber == newLesson.weekNumber &&
                oldLesson.timeStart == newLesson.timeStart
            }) == false {
                lessonsToRemove.append(oldLesson)
            }
        }
        
        if lessonsToRemove.isEmpty == false {
            removeFromLessons(NSSet(array: lessonsToRemove))
            LessonStorage.shared.delete(lessonsToRemove)
        }

        self.addToLessons(NSSet(array: updatedEmployee.lessons))
        
        self.educationStart = updatedEmployee.educationStart
        self.educationEnd = updatedEmployee.educationEnd
        self.examsStart = updatedEmployee.examsStart
        self.examsEnd = updatedEmployee.examsEnd
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
}
