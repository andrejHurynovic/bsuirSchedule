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
public class Group: NSManagedObject, Decodable {
    
    required public convenience init(from decoder: Decoder) throws {
        let context = PersistenceController.shared.container.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Group", in: context)!
        self.init(entity: entity, insertInto: context)
        
        var container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let groupInformation = try? container.nestedContainer(keyedBy: CodingKeys.self, forKey: .groupContainer) {
            let con = container
            container = groupInformation
            if let id = try? container.decode(String.self, forKey: .id) {
                self.id = id
                print(id)
            }
            container = con
        }

        
        if let educationStartString = try? container.decode(String.self, forKey: .educationStart) {
            self.educationStart = DateFormatters.shared.get(.shortDate).date(from: educationStartString)
            self.educationEnd = DateFormatters.shared.get(.shortDate).date(from: try! container.decode(String.self, forKey: .educationEnd))
        }
        
        if let examsStartString = try? container.decode(String.self, forKey: .examsStart) {
            self.examsStart = DateFormatters.shared.get(.shortDate).date(from: examsStartString)
            self.examsEnd = DateFormatters.shared.get(.shortDate).date(from: try! container.decode(String.self, forKey: .examsEnd))
        }
        
        if var schedules = try? container.decode([String:[Lesson]].self, forKey: .lessons) {
            schedules.keys.forEach { key in
                let weekDay = WeekDay(string: key)
                schedules[key]!.forEachInout { lesson in
                    //Assign every lesson correct weekday
                    lesson.weekday = weekDay.rawValue
                }
            }
            self.addToLessons(NSSet(array: Array(schedules.values.joined()) as! [Lesson]))
        }
        
        if let exams = try? container.decode([Lesson].self, forKey: .exams) {
            self.addToLessons(NSSet(array: exams))
        }
        
        //MARK: Group information
        //The studentGroup structure exists only when receiving a response to the Schedule request. It is needed for automatic merging when updating the group. Moreover, it can be either an update of the group with an already loaded schedule, or without it.
        //This fields is also contained when fetching all groups (), but located in root
        if let groupInformation = try? container.nestedContainer(keyedBy: CodingKeys.self, forKey: .groupContainer) {
            container = groupInformation
        }
        if let id = try? container.decode(String.self, forKey: .id) {
            self.id = id
            
            //MARK: Speciality
            let specialityID = try! container.decode(Int32.self, forKey: .specialityID)
            //If the specialty is unknown it is created from the available information
            if let speciality = SpecialityStorage.shared.values.value.first(where: {$0.id == specialityID}) {
                self.speciality = speciality
            } else {
                
                //MARK: Faculty
                //If the faculty is unknown it is created from the available information
                let facultyID = try! container.decode(Int16.self, forKey: .facultyID)
                let faculty: Faculty
                if let existingFaculty = FacultyStorage.shared.faculty(id: facultyID) {
                    faculty = existingFaculty
                } else {
                    let facultyAbbreviation = try! container.decode(String.self, forKey: .facultyAbbreviation)
                    faculty = Faculty(id: facultyID, abbreviation: facultyAbbreviation)
                }
                
                let specialityName = try! container.decode(String.self, forKey: .specialityName)
                let specialityAbbreviation = try! container.decode(String.self, forKey: .specialityAbbreviation)
                self.speciality = Speciality(id: specialityID, name: specialityName, abbreviation: specialityAbbreviation, faculty: faculty)
            }
        }
        
        if let course = try? container.decode(Int16.self, forKey: .course) {
            self.course = course
        }
    }
}



private enum CodingKeys: String, CodingKey {
    case id = "name"
    
    case educationStart = "startDate"
    case educationEnd = "endDate"
    case examsStart = "startExamsDate"
    case examsEnd = "endExamsDate"
    
    case lessons = "schedules"
    case exams = "exams"
    
    //Group information container keys
    case groupContainer = "studentGroupDto"
    
    case course
    case specialityID = "specialityDepartmentEducationFormId"
    case specialityName = "specialityName"
    case specialityAbbreviation = "specialityAbbrev"
    case facultyID = "facultyId"
    case facultyAbbreviation = "facultyAbbrev"
}
