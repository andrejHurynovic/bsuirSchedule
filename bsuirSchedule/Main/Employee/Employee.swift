//
//  Employee.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 7.09.21.
//

import CoreData

extension Employee {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Employee> {
        let request = NSFetchRequest<Employee>(entityName: "Employee")
        request.sortDescriptors = [NSSortDescriptor(keyPath: (\Employee.lastName), ascending: true),
                                   NSSortDescriptor(keyPath: (\Employee.firstName), ascending: true),
                                   NSSortDescriptor(keyPath: (\Employee.middleName), ascending: true)]
        return request
    }
    
    @NSManaged public var id: Int32
    @NSManaged public var urlID: String?
    @NSManaged public var firstName: String
    @NSManaged public var middleName: String?
    @NSManaged public var lastName: String
    
    @NSManaged public var rank: String?
    @NSManaged public var degree: Degree?
    @NSManaged public var departments: NSSet?
    @NSManaged public var favorite: Bool
    @NSManaged public var lessonsUpdateDate: Date?
    
    @NSManaged public var educationStart: Date?
    @NSManaged public var educationEnd: Date?
    @NSManaged public var examsStart: Date?
    @NSManaged public var examsEnd: Date?
    
    @NSManaged public var photoLink: String?
    @NSManaged public var photo: Data?
    
    @NSManaged public var lessons: NSSet?
}

//MARK: - Generated accessors

extension Employee {
    @objc(addLessonsObject:)
    @NSManaged public func addToLessons(_ value: Lesson)
    @objc(removeLessonsObject:)
    @NSManaged public func removeFromLessons(_ value: Lesson)
    @objc(addLessons:)
    @NSManaged public func addToLessons(_ values: NSSet)
    @objc(removeLessons:)
    @NSManaged public func removeFromLessons(_ values: NSSet)
    @objc(addDepartmentsObject:)
    @NSManaged public func addToDepartments(_ value: Department)
    @objc(removeDepartmentsObject:)
    @NSManaged public func removeFromDepartments(_ value: Department)
    @objc(addDepartments:)
    @NSManaged public func addToDepartments(_ values: NSSet)
    @objc(removeDepartments:)
    @NSManaged public func removeFromDepartments(_ values: NSSet)
    @objc(addCompoundSchedulesObject:)
    @NSManaged public func addToCompoundSchedules(_ value: CompoundSchedule)
    @objc(removeCompoundSchedulesObject:)
    @NSManaged public func removeFromCompoundSchedules(_ value: CompoundSchedule)
    @objc(addCompoundSchedules:)
    @NSManaged public func addToCompoundSchedules(_ values: NSSet)
    @objc(removeCompoundSchedules:)
    @NSManaged public func removeFromCompoundSchedules(_ values: NSSet)

}
