//
//  DateFormatters.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 21.04.22.
//

import Foundation

class DateFormatters {
    
    enum DateFormattersType {
        case shortDate
        case shortDateWithTime
        case longDate
        case longDateWithTime
        case time
    }
    
    static let shared = DateFormatters()
    
    var shortDate: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter
    }
    
    var shortDateWithTime: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        return dateFormatter
    }
    var longDate: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter
    }
    var longDateWithTime: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
        return dateFormatter
    }
    var time: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }
    
    func get(_ type: DateFormattersType) -> DateFormatter {
        switch type {
        case .shortDate:
            return shortDate
        case .shortDateWithTime:
            return shortDateWithTime
        case .longDate:
            return longDate
        case .longDateWithTime:
            return longDateWithTime
        case .time:
            return time
        }
    }
    
}
