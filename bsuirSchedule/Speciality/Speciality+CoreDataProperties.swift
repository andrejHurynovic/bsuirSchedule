//
//  Speciality+CoreDataProperties.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 15.10.21.
//
//

import Foundation
import CoreData


extension Speciality {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Speciality> {
        let request = NSFetchRequest<Speciality>(entityName: "Speciality")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Speciality.name, ascending: true),
                                   NSSortDescriptor(keyPath: \Speciality.educationTypeValue, ascending: true)]
        return request
    }
    
    @NSManaged public var id: Int32
    @NSManaged public var name: String!
    @NSManaged public var abbreviation: String!
    
    @NSManaged public var educationTypeValue: Int16
    @NSManaged public var code: String?
    
    @NSManaged public var faculty: Faculty!
    @NSManaged public var groups: NSSet?
    
}

// MARK: Generated accessors for groups
extension Speciality {
    
    @objc(addGroupsObject:)
    @NSManaged public func addToGroups(_ value: Group)
    
    @objc(removeGroupsObject:)
    @NSManaged public func removeFromGroups(_ value: Group)
    
    @objc(addGroups:)
    @NSManaged public func addToGroups(_ values: NSSet)
    
    @objc(removeGroups:)
    @NSManaged public func removeFromGroups(_ values: NSSet)
    
}

//MARK: EducationType

enum EducationType: Int16, CaseIterable {
    case unknown = 0
    case fullTime = 1
    case distant = 2
    case remote = 3
    case night = 4
    
    var description: String {
        switch self {
        case .unknown:
            return "неизвестно"
        case .fullTime:
            return "дневная"
        case .distant:
            return "заочная"
        case .remote:
            return "дистанционная"
        case .night:
            return "вечерняя"
        }
    }
}

extension Speciality : Identifiable {
    
    var educationType: EducationType {
        EducationType(rawValue: educationTypeValue)!
    }
}

extension Speciality {
    ///Name + education type + faculty abbreviation
    public override var description: String {
        "\(self.name!) (\(self.educationType.description), \(self.faculty!.abbreviation!))"
    }
}
