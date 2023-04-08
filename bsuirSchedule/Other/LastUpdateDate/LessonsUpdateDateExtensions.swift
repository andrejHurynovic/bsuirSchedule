//
//  LessonsUpdateDateExtensions.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 9.04.23.
//

import Foundation

extension Group: LessonsUpdateDateable {
    func fetchLastUpdateDate() async -> Date? {
        guard let data = try? await URLSession.shared.data(from: FetchDataType.groupUpdateDate.rawValue + self.id) else { return nil }
        
        guard let lastUpdateDate = try? JSONDecoder().decode(LastUpdateDate.self, from: data) else { return nil }
        return lastUpdateDate.date
    }
}

extension Employee: LessonsUpdateDateable {
    func fetchLastUpdateDate() async -> Date? {
        guard let urlID = self.urlID,
              let data = try? await URLSession.shared.data(from: FetchDataType.employeeUpdateDate.rawValue + urlID) else { return nil }
        
        guard let lastUpdateDate = try? JSONDecoder().decode(LastUpdateDate.self, from: data) else { return nil }
        return lastUpdateDate.date
    }
}
