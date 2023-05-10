//
//  DateFormatters.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 21.04.22.
//

import Foundation

struct DateFormatters {
    
    // MARK: - DateFormatters
    
    ///Date formatter with format "dd.MM.yyyy"
    static let short = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter
    }()
    ///Date formatter with format "dd.MM.yyyy HH:mm"
    static let shortDateWithTime = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        return dateFormatter
    }()
    ///Date formatter with format "dd MMM yyyy"
    static let longDate = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter
    }()
    ///Date formatter with format "dd MMM yyyy HH:mm"
    static let longDateWithTime = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
        return dateFormatter
    }()
    ///Date formatter with format "HH:mm"
    static let time = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }()
    
    // MARK: - RelativeDateFormatters
    
    static let relativeNamed = {
        let relativeDateTimeFormatter = RelativeDateTimeFormatter()
        relativeDateTimeFormatter.dateTimeStyle = .named
        return relativeDateTimeFormatter
    }()
    
}
