//
//  LastUpdateDate.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 31.05.22.
//

import Foundation

struct LastUpdateDate {
    var date: Date
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        guard let dateString = try? container.decode(String.self, forKey: .date) else { throw URLError(.badServerResponse) }
        self.date = DateFormatters.short.date(from: dateString)!
    }
    
}

extension LastUpdateDate: Decodable {
    private enum CodingKeys: String, CodingKey {
        case date = "lastUpdateDate"
    }
}
