//
//  ColorRawRepresentable.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 21.10.21.
//

import SwiftUI

extension Color: RawRepresentable {
    public init?(rawValue: Data) {
        #if os(iOS)
        guard let uiColor = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSColor.self, from: rawValue) else {
            self = .primary
            return
        }
        self = Color(uiColor)
        #elseif os(macOS)
        guard let nsColor = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSColor.self, from: rawValue) else {
            self = .primary
            return
        }
        self = Color(nsColor)
        #endif

    }
    
    public var rawValue: Data {
        #if os(iOS)
        try! NSKeyedArchiver.archivedData(withRootObject: UIColor(self),
                                          requiringSecureCoding: false)
        #elseif os(macOS)
        try! NSKeyedArchiver.archivedData(withRootObject: NSColor(self),
                                          requiringSecureCoding: false)
        #endif
    }
}
