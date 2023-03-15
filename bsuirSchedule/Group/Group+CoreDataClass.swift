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
//        Log.info("Group (\(String(self.id))) has been created, start updating")
    }
    
}

//MARK: Update

extension Group: DecoderUpdatable {
    //MARK: Update
    func update(from decoder: Decoder) throws {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        var container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let educationStartString = try? container.decode(String.self, forKey: .educationStart) {
            self.educationStart = DateFormatters.shared.get(.shortDate).date(from: educationStartString)
            self.educationEnd = DateFormatters.shared.get(.shortDate).date(from: try! container.decode(String.self, forKey: .educationEnd))
        }
        
        if let examsStartString = try? container.decode(String.self, forKey: .examsStart) {
            self.examsStart = DateFormatters.shared.get(.shortDate).date(from: examsStartString)
            self.examsEnd = DateFormatters.shared.get(.shortDate).date(from: try! container.decode(String.self, forKey: .examsEnd))
        }
        
        
        if let schedulesDictionary = try? container.decode(Dictionary.self, forKey: .lessons) {
            let lessonDecoder = JSONDecoder()
            lessonDecoder.userInfo[.managedObjectContext] = decoder.userInfo[.managedObjectContext]
            lessonDecoder.userInfo[.groups] = decoder.userInfo[.groups]
            lessonDecoder.userInfo[.employees] = decoder.userInfo[.employees]
            lessonDecoder.userInfo[.classrooms] = decoder.userInfo[.classrooms]
            lessonDecoder.userInfo[.specialities] = decoder.userInfo[.specialities]
            lessonDecoder.userInfo[.updatedGroups] = Set<String>()
            
            
            schedulesDictionary.forEach { (key: String, value: Any) in
                let weekDay = WeekDay(string: key)
                let lessonsDictionary = value as? [Any]
                lessonsDictionary?.forEach({ lessonDictionary in
                    
                    let lesson = try! lessonDecoder.decode(Lesson.self, from: JSONSerialization.data(withJSONObject: lessonDictionary))
                    lessonDecoder.userInfo[.updatedGroups] = (lessonDecoder.userInfo[.updatedGroups] as! Set<String>).union((lesson.groups?.allObjects as! [Group]).map({$0.id }))
                    lesson.weekday = weekDay.rawValue
                
                })
            }
        }
        
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
        if let course = try? container.decode(Int16.self, forKey: .course) {
            self.course = course
        }
        
        try! updateSpeciality(from: decoder, container: container)
        
        Log.info("Group (\(String(self.id))) has been updated, time: \((CFAbsoluteTimeGetCurrent() - startTime).roundTo(places: 3)) seconds")
    }
    
    private func updateSpeciality(from decoder: Decoder, container: KeyedDecodingContainer<Group.CodingKeys>) throws {
        
        if let specialityID = try? container.decode(Int32.self, forKey: .specialityID) {
            let specialities = decoder.userInfo[.specialities] as! [Speciality]
            if let speciality = specialities.first(where: { $0.id == specialityID }) {
                self.speciality = speciality
                Log.info("Speciality (\(String(self.speciality.id)) \(self.speciality.abbreviation!)) is found and assigned to group \(String(self.id))")
            } else {
                //If the specialty is unknown it is created from the available information.
                self.speciality = try createSpeciality(from: decoder, container: container, specialityID: specialityID)
                Log.warning("Speciality (\(String(self.speciality.id)) - \(self.speciality.abbreviation!)) is not found. The speciality was created and assigned to group \(String(self.id))")
            }
        }
    }
    
    private func createSpeciality(from decoder: Decoder, container: KeyedDecodingContainer<Group.CodingKeys>, specialityID: Int32) throws -> Speciality {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
//        контейнер киед бай факульти контейнер
        
        //MARK: Faculty
        //If the faculty is unknown it is created from the available information
        
        let facultyID = try! container.decode(Int16.self, forKey: .facultyID)
        
        let facultyAbbreviation = try! container.decode(String.self, forKey: .facultyAbbreviation)
        let faculty = Faculty(id: facultyID, abbreviation: facultyAbbreviation)
        
        let specialityName = try! container.decode(String.self, forKey: .specialityName)
        let specialityAbbreviation = try! container.decode(String.self, forKey: .specialityAbbreviation)

        let context = decoder.userInfo[.managedObjectContext] as! NSManagedObjectContext

        return Speciality(context: context, id: specialityID, name: specialityName, abbreviation: specialityAbbreviation, faculty: faculty)
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
    static let updatedGroups = CodingUserInfoKey(rawValue: "updatedGroups")!
    static let groupUpdating = CodingUserInfoKey(rawValue: "groupUpdating")!
}
