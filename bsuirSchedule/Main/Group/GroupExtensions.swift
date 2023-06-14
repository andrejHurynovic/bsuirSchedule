//
//  GroupExtensions.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 11.04.23.
//

import Foundation

extension Group: Identifiable { }
extension Group: Favored {}

extension Group: EducationBounded { }
extension Group: EducationRanged { }

extension Group: Scheduled {
    var title: String { self.name }
}
extension Group: CompoundScheduled { }

//MARK: - Employee

extension Employee {
    var groups: [Group]? {
        guard let lessons = self.lessons?.allObjects as? [Lesson] else { return nil }
        
        let groups = Set(lessons.compactMap { $0.groups?.allObjects as? [Group] }
            .flatMap { $0 })
            .sorted { $0.name < $1.name }
        print(groups.map( { $0.name }))
        
        guard groups.isEmpty == false else { return nil }
        return groups
    }
}


//MARK: - Other

extension Group {
    var flow: [Group]? {
        guard var flow = self.speciality?.groups?.allObjects as? [Group] else { return nil }
        flow.removeAll { $0.course != self.course || $0 == self }

        guard flow.isEmpty == false else {
            return nil
        }
        return flow.sorted { $0.name < $1.name }
    }
    
}

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
