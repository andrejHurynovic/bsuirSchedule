//
//  Favored.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 7.04.23.
//

import SwiftUI
import CoreData

protocol Favored: ObservableObject, NSManagedObject {
    var favroite: Bool { get set }
}
