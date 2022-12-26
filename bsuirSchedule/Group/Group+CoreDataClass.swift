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
    
    required public convenience init(from decoder: Decoder) throws {
        let context = decoder.userInfo[.managedObjectContext] as! NSManagedObjectContext
        self.init(entity: Group.entity(), insertInto: context)
        
        try! self.update(from: decoder)
    }
    
}

//MARK: Update

extension Group: DecoderUpdatable {
    //MARK: Update
    func update(from decoder: Decoder) throws {
        var container = try decoder.container(keyedBy: CodingKeys.self)
        
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
        }
        
        //Exams also presented in schedules
//        let _ = try? container.decode([Lesson].self, forKey: .exams)
        
        //MARK: Group information
        //The studentGroup structure exists only when receiving a response to the Schedule request. It is needed for automatic merging when updating the group. Moreover, it can be either an update of the group with an already loaded schedule, or without it.
        //This fields is also contained when fetching all groups, but located in root
        if let groupInformation = try? container.nestedContainer(keyedBy: CodingKeys.self, forKey: .groupContainer) {
            container = groupInformation
        }
        self.id = try! container.decode(String.self, forKey: .id)
        if let numberOfStudents = try? container.decode(Int16.self, forKey: .numberOfStudents) {
            self.numberOfStudents = numberOfStudents
        }
        
        //MARK: Speciality
        if let specialityID = try? container.decode(Int32.self, forKey: .specialityID) {
            let specialities = decoder.userInfo[.specialities] as! [Speciality]
            if let speciality = specialities.first(where: { $0.id == specialityID }) {
                self.speciality = speciality
            } else {
                //If the specialty is unknown it is created from the available information
                
                //MARK: Faculty
                //If the faculty is unknown it is created from the available information
                let facultyID = try! container.decode(Int16.self, forKey: .facultyID)
                let faculty: Faculty
                
                let facultyAbbreviation = try! container.decode(String.self, forKey: .facultyAbbreviation)
                faculty = Faculty(id: facultyID, abbreviation: facultyAbbreviation)
                
                
                let specialityName = try! container.decode(String.self, forKey: .specialityName)
                let specialityAbbreviation = try! container.decode(String.self, forKey: .specialityAbbreviation)
    
                let context = decoder.userInfo[.managedObjectContext] as! NSManagedObjectContext

                self.speciality = Speciality(context: context, id: specialityID, name: specialityName, abbreviation: specialityAbbreviation, faculty: faculty)
            }
            
            //For studentGroups structure in Lesson
            //        if let specialityCode = try? container.decode (String.self, forKey: .specialityCode) {
            //            if let speciality = Speciality.fetch(specialityCode: specialityCode, in: context) {
            //                self.speciality = speciality
            //            }
            //        }
            
            if let course = try? container.decode(Int16.self, forKey: .course) {
                self.course = course
            }
        }
    }
}

extension Group: Decodable {
    private enum CodingKeys: String, CodingKey {
        case educationStart = "startDate"
        case educationEnd = "endDate"
        case examsStart = "startExamsDate"
        case examsEnd = "endExamsDate"
        
        case lessons = "schedules"
        case exams = "exams"
        
        //Group information container keys
        case groupContainer = "studentGroupDto"
        
        case id = "name"
        case numberOfStudents
        case course
        case specialityID = "specialityDepartmentEducationFormId"
        case specialityCode
        case specialityName
        case specialityAbbreviation = "specialityAbbrev"
        case facultyID = "facultyId"
        case facultyAbbreviation = "facultyAbbrev"
    }
}

//MARK: CodingUserInfoKey
extension CodingUserInfoKey {
    static let groups = CodingUserInfoKey(rawValue: "groups")!
}
