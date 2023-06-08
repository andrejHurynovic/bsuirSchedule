//
//  GroupDecoder.swift
//  Group
//
//  Created by Andrej Hurynovič on 6.09.21.
//

import CoreData

@objc(Group)
public class Group: NSManagedObject {
    required public convenience init(from decoder: Decoder) throws {
        self.init(context: decoder.userInfo[.managedObjectContext] as! NSManagedObjectContext)
        try! self.update(from: decoder)
        Log.info("Group (\(String(self.name))) has been created.")
    }
}

//MARK: - Update

extension Group: DecoderUpdatable {
    func update(from decoder: Decoder) throws {
        let startTime = CFAbsoluteTimeGetCurrent()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        decodeGroup(decoder)
        decodeEducationDates(decoder)
        decodeSpeciality(decoder)
        decodeLessons(container)
        
        self.lessonsUpdateDate = Date()
        
        Log.info("Group (\(String(self.name))) has been updated, time: \((CFAbsoluteTimeGetCurrent() - startTime).roundTo(places: 3)) seconds")
    }
    
    private func decodeGroup(_ decoder: Decoder) {
        //The group information structure nested container exists only when receiving a response to the Schedule (Group) request. This fields is also contained when fetching all groups, but located in root.
        let container = (try? decoder.container(keyedBy: CodingKeys.self)
            .nestedContainer(keyedBy: CodingKeys.self, forKey: .groupNestedContainer))
        ?? (try! decoder.container(keyedBy: CodingKeys.self))
        
        self.name = try! container.decode(String.self, forKey: .id)
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
        Log.info("The speciality (\(String(describing: self.speciality?.id)) - \(String(describing: self.speciality?.abbreviation))) is created and assigned to group \(String(self.name))")
        
    }
    
    private func decodeLessons(_ container: KeyedDecodingContainer<Group.CodingKeys>) {
        let _ = try? container.decode([String:[Lesson]].self, forKey: .lessons)
        let _ = try? container.decode([Lesson].self, forKey: .exams)
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



//MARK: - CodingUserInfoKey
extension CodingUserInfoKey {
    ///A boolean value that indicates that container should be decoded as being received from a Group container. Required for Faculty and Speciality decoding.
    static let groupEmbeddedContainer = CodingUserInfoKey(rawValue: "groupEmbeddedContainer")!
}
