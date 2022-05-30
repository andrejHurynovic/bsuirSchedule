//
//  DateFormatters.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 21.04.22.
//

import Foundation

class DateFormatters {
    
    var dateFormatterHHmm: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }
    
    var dateFormatterddMMyyyy: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter
    }
    
    
    
    static let shared = DateFormatters()
    
}
