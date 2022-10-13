//
//  LastUpdateDate.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 31.05.22.
//

import Foundation

struct LastUpdateDate {
    var lastUpdateDate: Date!
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let dateString = try? container.decode(String.self, forKey: .date) {
            self.lastUpdateDate = DateFormatters.shared.get(.shortDate).date(from: dateString)!
        }
    }

}

extension LastUpdateDate: Decodable {
    private enum CodingKeys: String, CodingKey {
        case date = "lastUpdateDate"
    }
}
