//
//  Lessonable.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 30.05.22.
//

import Foundation
import CoreData

protocol Lessonable: NSManagedObject {
    var favorite: Bool { get set }
    var lessons: NSSet? { get }
    
    var educationStart: Date? { get }
    var educationEnd: Date? { get }
    var examsStart: Date? { get }
    var examsEnd: Date? { get }
    
    var educationDates: [Date] {get}
    var examsDates: [Date] {get}
    var educationRange: ClosedRange<Date>? {get}
}
