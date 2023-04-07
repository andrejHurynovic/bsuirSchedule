//
//  Favoritable.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 7.04.23.
//

import SwiftUI
import CoreData

protocol Favoritable: ObservableObject, NSManagedObject {
    var favourite: Bool { get set }
}
