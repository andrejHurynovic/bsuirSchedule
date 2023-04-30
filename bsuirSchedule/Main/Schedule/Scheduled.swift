//
//  Scheduled.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 25.09.22.
//

import CoreData

protocol Scheduled: Favored,
                    EducationRanged,
                    DefaultLessonViewSettings {
    var lessons: NSSet? { get }
    var title: String { get }
}
