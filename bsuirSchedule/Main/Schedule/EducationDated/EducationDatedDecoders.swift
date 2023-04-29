//
//  EducationDatedDecoders.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 27.04.23.
//

import Foundation

extension Group {
    func decodeEducationDates(_ decoder: Decoder) {
        let container = try! decoder.container(keyedBy: EducationDatesCodingKeys.self)
        if let educationStartString = try? container.decode(String.self, forKey: .educationStart) {
            self.educationStart = DateFormatters.shared.get(.shortDate).date(from: educationStartString)
            self.educationEnd = DateFormatters.shared.get(.shortDate).date(from: try! container.decode(String.self, forKey: .educationEnd))
        }
        if let examsStartString = try? container.decode(String.self, forKey: .examsStart) {
            self.examsStart = DateFormatters.shared.get(.shortDate).date(from: examsStartString)
            self.examsEnd = DateFormatters.shared.get(.shortDate).date(from: try! container.decode(String.self, forKey: .examsEnd))
        }
    }
}

extension Employee {
    func decodeEducationDates(_ decoder: Decoder) {
        let container = try! decoder.container(keyedBy: EducationDatesCodingKeys.self)
        if let educationStartString = try? container.decode(String.self, forKey: .educationStart) {
            self.educationStart = DateFormatters.shared.get(.shortDate).date(from: educationStartString)
            self.educationEnd = DateFormatters.shared.get(.shortDate).date(from: try! container.decode(String.self, forKey: .educationEnd))
        }
        if let examsStartString = try? container.decode(String.self, forKey: .examsStart) {
            self.examsStart = DateFormatters.shared.get(.shortDate).date(from: examsStartString)
            self.examsEnd = DateFormatters.shared.get(.shortDate).date(from: try! container.decode(String.self, forKey: .examsEnd))
        }
    }
}

fileprivate enum EducationDatesCodingKeys: String, CodingKey {
    case educationStart = "startDate"
    case educationEnd = "endDate"
    
    case examsStart = "startExamsDate"
    case examsEnd = "endExamsDate"
}
