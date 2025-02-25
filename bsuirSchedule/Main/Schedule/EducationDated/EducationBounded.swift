//
//  EducationBounded.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 27.04.23.
//

import Foundation

protocol EducationBounded {
    /// Education start date if provided by the API
    var educationStart: Date? { get set }
    /// Education end date if provided by the API
    var educationEnd: Date? { get set }
    /// Exams start date if provided by the API
    var examsStart: Date? { get set }
    /// Exams end date if provided by the API
    var examsEnd: Date? { get set }
}

extension Group {
    func decodeEducationDates(_ decoder: Decoder) {
        let container = try! decoder.container(keyedBy: EducationDatesCodingKeys.self)
        if let educationStartString = try? container.decode(String.self, forKey: .educationStart) {
            self.educationStart = DateFormatters.short.date(from: educationStartString)
            self.educationEnd = DateFormatters.short.date(from: try! container.decode(String.self, forKey: .educationEnd))
        }
        if let examsStartString = try? container.decode(String.self, forKey: .examsStart) {
            self.examsStart = DateFormatters.short.date(from: examsStartString)
            self.examsEnd = DateFormatters.short.date(from: try! container.decode(String.self, forKey: .examsEnd))
        }
    }
}

extension Employee {
    func decodeEducationDates(_ decoder: Decoder) {
        let container = try! decoder.container(keyedBy: EducationDatesCodingKeys.self)
        if let educationStartString = try? container.decode(String.self, forKey: .educationStart) {
            self.educationStart = DateFormatters.short.date(from: educationStartString)
            self.educationEnd = DateFormatters.short.date(from: try! container.decode(String.self, forKey: .educationEnd))
        }
        if let examsStartString = try? container.decode(String.self, forKey: .examsStart) {
            self.examsStart = DateFormatters.short.date(from: examsStartString)
            self.examsEnd = DateFormatters.short.date(from: try! container.decode(String.self, forKey: .examsEnd))
        }
    }
}

fileprivate enum EducationDatesCodingKeys: String, CodingKey {
    case educationStart = "startDate"
    case educationEnd = "endDate"
    
    case examsStart = "startExamsDate"
    case examsEnd = "endExamsDate"
}
