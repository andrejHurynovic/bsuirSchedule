//
//  ColorRawRepresentable.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 21.10.21.
//

import SwiftUI

extension Color: RawRepresentable {
    public init?(rawValue: Data) {
        guard let uiColor = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: rawValue) else {
            self = .primary
            return
        }
        self = Color(uiColor: uiColor)
    }
    
    public var rawValue: Data {
        try! NSKeyedArchiver.archivedData(withRootObject: UIColor(self),
                                          requiringSecureCoding: false)
    }
}
