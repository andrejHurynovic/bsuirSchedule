//
//  GroupExtensions.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 11.04.23.
//

import Foundation

//MARK: - Employee

extension Employee {
    var groups: [Group]? {
        guard let lessons = self.lessons?.allObjects as? [Lesson] else { return nil }
        
        let groups = Set(lessons.compactMap { $0.groups?.allObjects as? [Group] }
            .flatMap { $0 })
            .sorted { $0.id < $1.id }
        
        guard groups.isEmpty == false else { return nil }
        return groups
    }
}


//MARK: - Accessors
extension Group {
    var flow: [Group]? {
        guard var flow = self.speciality?.groups?.allObjects as? [Group] else { return nil }
        flow.removeAll { $0.course != self.course || $0 == self }

        guard flow.isEmpty == false else {
            return nil
        }
        return flow.sorted { $0.id < $1.id }
    }
    
}

//MARK: - Additional
extension Array where Element == Group {
    func description() -> String {
        guard self.isEmpty == false else {
                return ""
            }
        
        guard self.count > 1 else {
            return self.first!.name
        }
        
        var groups = self.map { $0.name }.sorted()
            var nearGroups: [String] = []
            var finalGroups: [String] = []
            
            repeat {
                nearGroups.removeAll()
                nearGroups.append(groups.removeFirst())
                if groups.isEmpty == false {
                    while groups.isEmpty == false, Int(groups.first!)! - Int(nearGroups.last!)! == 1 {
                        nearGroups.append(groups.removeFirst())
                    }
                    if nearGroups.count > 1 {
                        finalGroups.append("\(nearGroups.first!)-\((String(nearGroups.last!)).last!)")
                    } else {
                        finalGroups.append(String(nearGroups.first!))
                    }
                    
                } else {
                    finalGroups.append(String(nearGroups.first!))
                }
                
            } while (groups.isEmpty == false)
            return finalGroups.joined(separator: ", ")
    }
}
