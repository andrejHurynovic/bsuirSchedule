//
//  LessonsRefreshable.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 09.04.23.
//

import CoreData

protocol LessonsRefreshable: NSManagedObject {
    associatedtype AssociatedType
    
    var lessons: NSSet? { get }
    var lessonsUpdateDate: Date? { get set }
    
    func update() async -> AssociatedType
    func fetchLastUpdateDate() async -> Date?
}

//MARK: checkForLessonsUpdates()

extension LessonsRefreshable {
    func checkForLessonsUpdates() async -> Bool {
        if [self.lessonsUpdateDate == nil,
            self.lessons == nil,
            self.lessons?.allObjects.isEmpty].contains(true) {
            let _ = await self.update()
            return true
        }
        
        if let fetchedLastUpdateDate = await fetchLastUpdateDate(),
           let scheduledItemLastUpdateDate = self.lessonsUpdateDate,
           scheduledItemLastUpdateDate < fetchedLastUpdateDate {
            let _ = await self.update()
            return true
        }
        return false
        
    }
}

//MARK: fetchLastUpdateDate()

extension Group: LessonsRefreshable {
    func fetchLastUpdateDate() async -> Date? {
        guard let data = try? await URLSession.shared.data(from: FetchDataType.groupUpdateDate.rawValue + self.id) else { return nil }
        
        guard let lastUpdateDate = try? JSONDecoder().decode(LastUpdateDate.self, from: data) else { return nil }
        return lastUpdateDate.date
    }
}

extension Employee: LessonsRefreshable {
    func fetchLastUpdateDate() async -> Date? {
        guard let urlID = self.urlID,
              let data = try? await URLSession.shared.data(from: FetchDataType.employeeUpdateDate.rawValue + urlID) else { return nil }
        
        guard let lastUpdateDate = try? JSONDecoder().decode(LastUpdateDate.self, from: data) else { return nil }
        return lastUpdateDate.date
    }
}
