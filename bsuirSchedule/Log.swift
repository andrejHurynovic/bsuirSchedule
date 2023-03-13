//
//  Log.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 13.03.23.
//

import Foundation

enum Log {
    enum LogLevel {
        case info
        case warning
        case error
        
        fileprivate var prefix: String {
            switch self {
            case .info:
                return "INFO"
            case .warning:
                return "WARNING"
            case .error:
                return "ERROR"
            }
        }
    }
    
    
    struct Context {
        let file: String
        let function: String
        let line: Int
        var description: String {
            return "\((file as NSString).lastPathComponent): \(line) \(function)"
        }
    }
    
    static func info(_ string: String, shouldLogContext: Bool = false, file: String = #file, function: String = #function, line: Int = #line) {
        let context = Context(file: file, function: function, line: line)
        Log.handleLog (level: .info, string: string.description, shouldLogContext: shouldLogContext, context: context)
    }
    static func warning(_ string: String, shouldLogContext: Bool = false, file: String = #file, function: String = #function, line: Int = #line) {
        let context = Context(file: file, function: function, line: line)
        Log.handleLog(level: .warning, string: string.description, shouldLogContext: shouldLogContext, context: context)
    }
    static func error(_ string: String, shouldLogContext: Bool = false, file: String = #file, function: String = #function, line: Int = #line) {
        let context = Context(file: file, function: function, line: line)
        Log.handleLog (level: .error, string: string.description, shouldLogContext: shouldLogContext, context: context)
    }
    
    fileprivate static func handleLog(level: LogLevel, string: String, shouldLogContext: Bool = true, context: Context) {
        let logComponents = ["[\(level.prefix)]", string]
        var fullString = logComponents.joined (separator: " " )
        if shouldLogContext {
            fullString += " ← \(context.description) "
        }
        
#if DEBUG
        print (fullString)
#endif
        
    }
    
}
