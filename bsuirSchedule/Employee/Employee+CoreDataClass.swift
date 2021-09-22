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
//        self.photo = employee.photo
    }
    
    func update(_ updatedEmployee: EmployeeModel) {
        self.removeFromLessons(self.lessons!)
        self.addToLessons(NSSet(array: updatedEmployee.lessons))
        
        self.educationStart = updatedEmployee.educationStart
        self.educationEnd = updatedEmployee.educationEnd
        self.examsStart = updatedEmployee.examsStart
        self.examsEnd = updatedEmployee.examsEnd
    }
    
    convenience init(id: Int32, urlID: String?, firstName: String?, middleName: String?, lastName: String?, rank: String?, degree: String?, departments: [String]?, favorite: Bool, photoLink: String?, photo: UIImage?) {
        let context = PersistenceController.shared.container.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Employee", in: context)
        self.init(entity: entity!, insertInto: context)
        
        self.id = id
        self.urlID = urlID
        self.firstName = firstName
        self.middleName = middleName
        self.lastName = lastName
        self.rank = rank
        self.degree = degree
        self.departments = departments
        self.favorite = favorite
        self.photoLink = photoLink
//        self.photo = photo
    }
    
}
