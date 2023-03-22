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
        Log.info("Group (\(String(self.id))) has been created.")
    }
    
}

//MARK: Update

extension Group: DecoderUpdatable {
    //MARK: Update
    func update(from decoder: Decoder) throws {
        let startTime = CFAbsoluteTimeGetCurrent()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        decodeGroup(decoder)
        decodeEducationDates(decoder)
        decodeSpeciality(decoder)
        
        let _ = try? container.decode([String:[Lesson]].self, forKey: .lessons)
        let _ = try? container.decode([Lesson].self, forKey: .exams)

        Log.info("Group (\(String(self.id))) has been updated, time: \((CFAbsoluteTimeGetCurrent() - startTime).roundTo(places: 3)) seconds")
    }
    
    private func decodeGroup(_ decoder: Decoder) {
        //The group information structure nested container exists only when receiving a response to the Schedule (Group) request. This fields is also contained when fetching all groups, but located in root.
        let container = (try? decoder.container(keyedBy: CodingKeys.self)
            .nestedContainer(keyedBy: CodingKeys.self.self, forKey: .groupNestedContainer))
        ?? (try! decoder.container(keyedBy: CodingKeys.self))
        
        self.id = try! container.decode(String.self, forKey: .id)
        if let course = try? container.decode(Int16.self, forKey: .course) {
            self.course = course
            }
        self.educationDegreeValue = try! container.decode(Int16.self, forKey: .educationDegree)
        
        //Number of student presented only in Lesson group data.
        if let numberOfStudents = try? container.decode(Int16.self, forKey: .numberOfStudents) {
            self.numberOfStudents = numberOfStudents
        }
    
    }
    
    private func decodeSpeciality(_ decoder: Decoder) {
        let container = (try? decoder.container(keyedBy: CodingKeys.self)
            .nestedContainer(keyedBy: CodingKeys.self.self, forKey: .groupNestedContainer))
        ?? (try! decoder.container(keyedBy: CodingKeys.self))
        guard let _ = try? container.decode(Int32.self, forKey: .specialityID) else { return }
        self.speciality = try! Speciality(from: decoder)
        Log.info("The speciality (\(String(self.speciality.id)) - \(self.speciality.abbreviation!)) is created and assigned to group \(String(self.id))")
        
    }
    
}

extension Group: Decodable {
    private enum CodingKeys: String, CodingKey {
        case lessons = "schedules"
        case exams = "exams"
        
        case groupNestedContainer = "studentGroupDto"
        
        case id = "name"
        case numberOfStudents
        case educationDegree = "educationDegree"
        case course
        case specialityID = "specialityDepartmentEducationFormId"
    }
}

//MARK: CodingUserInfoKey
extension CodingUserInfoKey {
    static let groups = CodingUserInfoKey(rawValue: "groups")!
    static let groupContainer = CodingUserInfoKey(rawValue: "groupContainer")!
    static let updatedGroups = CodingUserInfoKey(rawValue: "updatedGroups")!
    static let groupUpdating = CodingUserInfoKey(rawValue: "groupUpdating")!
}
