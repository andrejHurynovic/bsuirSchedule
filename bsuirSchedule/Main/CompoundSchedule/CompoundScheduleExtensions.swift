//
//  CompoundScheduleExtensions.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 14.06.23.
//

import Foundation

extension CompoundSchedule {
    var allScheduled: [any CompoundScheduled] { [self.auditories?.allObjects as? [any CompoundScheduled],
                                             self.employees?.allObjects as? [any CompoundScheduled],
                                             self.groups?.allObjects as? [any CompoundScheduled]]
        .compactMap { $0 }
        .flatMap { $0 }
    }
    
}


extension CompoundSchedule: Scheduled {
    
    
    var lessons: NSSet? {
        guard self.allScheduled.isEmpty == false else { return nil }
       
        let allAllLessons: [[Lesson]] = allScheduled.compactMap { $0.lessons?.allObjects as? [Lesson] }
        let allLessons: [Lesson] = allAllLessons.flatMap { $0 } as [Lesson]
            
        
        return NSSet(array: allLessons)
    }
    
    var title: String { self.name! }
    
    var favorite: Bool {
        get { return true }
        set { }
    }
    
    static func defaultLessonConfiguration() -> LessonViewConfiguration {
        LessonViewConfiguration(showGroups: true,
                                showEmployees: true)
    }
    
}
