//
//  ColorRawRepresentable.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 21.10.21.
//

import SwiftUI

extension Color: RawRepresentable {
    public init?(rawValue: String) {
        #if os(iOS)
        guard let data = Data(base64Encoded: rawValue),
              let uiColor = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data) else {
            self = .primary
            return
        }
        self = Color(uiColor)
        #elseif os(macOS)
        guard let data = Data(base64Encoded: rawValue),
              let nsColor = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSColor.self, from: data) else {
            self = .primary
            return
        }
        self = Color(nsColor)
        #endif

    }
    
    public var rawValue: String {
        #if os(iOS)
        try! NSKeyedArchiver.archivedData(withRootObject: UIColor(self),
                                          requiringSecureCoding: false).base64EncodedString()
        #elseif os(macOS)
        try! NSKeyedArchiver.archivedData(withRootObject: NSColor(self),
                                          requiringSecureCoding: false).base64EncodedString()
        #endif
    }
}
